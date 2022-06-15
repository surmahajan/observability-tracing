from __future__ import print_function

import logging
import secrets
import time
import sys

import requests
from flask import Flask
from flask import _request_ctx_stack as stack
from flask import session
from jaeger_client import Tracer, ConstSampler
from jaeger_client.reporter import LoggingReporter
from jaeger_client.codecs import B3Codec
from jaeger_client import Config
from opentracing.ext import tags
from opentracing.propagation import Format
from opentracing_instrumentation.request_context import get_current_span, span_in_context

try:
    import http.client as http_client
except ImportError:
    # Python 2
    import httplib as http_client

http_client.HTTPConnection.debuglevel = 1

app = Flask(__name__)

def init_tracer(service):
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(message)s', level=logging.DEBUG)

    config = Config(
        config={ # usually read from some yaml config
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
            'reporter_batch_size': 1
        },
        service_name=service
    )

    return config.initialize_tracer()

@app.route("/")
def say_hello():
    with tracer.start_active_span('say-hello', finish_on_close=True) as scope:
        headers = {
            "x-request-id": str(secrets.token_hex(16)),
            "x-b3-traceid": str(scope.span).split(":")[0],
            "x-b3-spanid": str(scope.span).split(":")[1],
            "x-b3-parentspanid": str(scope.span).split(":")[2]
        }
        scope.span.set_tag('hello-to', "oliver")
        hello_str = format_string("oliver", headers)
        call_java_app = java_app(headers)
        print_hello(hello_str + " " + call_java_app)

def format_string(hello_to, headers):
    with tracer.start_active_span('format', finish_on_close=True) as scope:
        hello_str = http_get("formatter", 9080, 'format', 'helloTo', hello_to, headers)
        scope.span.log_kv({'event': 'string-format', 'value': hello_str})
        return hello_str

def java_app(headers):
    with tracer.start_active_span('java', finish_on_close=True) as scope:
        java_str = http_get("java", 9080, 'a/hello', '', '', headers)
        scope.span.log_kv({'event': 'string-format', 'value': java_str})
        return java_str

def print_hello(hello_str):
    with tracer.start_active_span('println', finish_on_close=True) as scope:
        print(hello_str)
        scope.span.log_kv({'event': 'println'})


def http_get(host, port, path, param, value, headers):
    url = 'http://%s:%s/%s' % (host, port, path)

    span = tracer.active_span
    span.set_tag(tags.HTTP_METHOD, 'GET')
    span.set_tag(tags.HTTP_URL, url)
    span.set_tag(tags.SPAN_KIND, tags.SPAN_KIND_RPC_CLIENT)
    tracer.inject(span.context, Format.HTTP_HEADERS, headers)

    r = requests.get(url, params={param: value}, headers=headers)
    assert r.status_code == 200
    return r.text

tracer = init_tracer('hello-world')


# tracer = Tracer(
#     one_span_per_rpc=True,
#     service_name='hello-world',
#     reporter=LoggingReporter(),
#     sampler=ConstSampler(decision=True),
#     extra_codecs={Format.HTTP_HEADERS: B3Codec()},
# )

if __name__ == "__main__":
    if len(sys.argv) < 2:
        logging.error("usage: %s port" % (sys.argv[0]))
        sys.exit(-1)

    p = int(sys.argv[1])
    logging.info("start at port %s" % (p))
    # Make it compatible with IPv6 if Linux
    if sys.platform == "linux":
        app.run(host='::', port=p, debug=True, threaded=True)
    else:
        app.run(host='0.0.0.0', port=p, debug=True, threaded=True)
