## Grafana Installation

The file `grafana.yaml` will have the placeholders `CLUSTER_IP` and `PASSWORD` replaced by the values from the kubernetes clusters. This code can be found in the [deploy.sh](../../scripts/deploy.sh)

Once the deploy action is completed you can port-forward Grafana, and use the username and password as both `admin` log-in. You will see the following UI:

![Image](../../images/grafana-ui-1.png)
