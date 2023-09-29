# Litmus Quickstart

>Note: Much of this is taken from the [ChaosCenter Cluster Scope Installation] doc.
[ChaosCenter Cluster Scope Installation]: https://docs.litmuschaos.io/docs/getting-started/installation/

## Installation

You can install this on either a local (e.g. Docker Desktop) or remote kubernetes cluster (e.g. AKS). In either case, to install:

>Note: Only choose one of the following methods.
* Using Helm

    ```sh
    # Add to Helm
    helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
    # Separate out Litmus-specific resources into its own namespace
    kubectl create ns litmus
    # Install the helm chart onto the cluster
    # If the cluster is local, you can append "--set portal.frontend.service.type=NodePort"
    # example versions: 2.13.0, 2.14.0
    helm install chaos litmuschaos/litmus --namespace litmus --version <YOUR_LITMUS_VERSION>
    ```

* OR using `kubectl`

    ```sh
    # Separate out Litmus-specific resources into its own namespace
    kubectl create ns litmus
    # Apply a specific release YAML of Litmus
    # e.g. kubectl apply -f https://litmuschaos.github.io/litmus/2.14.0/litmus-2.14.0.yaml -n litmus
    kubectl apply -f https://litmuschaos.github.io/litmus/<YOUR_LITMUS_VERSION>/litmus-<YOUR_LITMUS_VERSION>.yaml -n litmus
    ```

## Accessing the Litmus UI

Instructions for accessing the Litmus ChaosCenter installed above will depend slightly depending on where Litmus is installed and how it's been exposed:

* **NodePort**

    If Litmus was exposed via `NodePort`, you should be able to access it from your browser at `<NODEIP>:<PORT>`. This also works with a LoadBalancer in the same way: `<LoadBalancerIP>:<PORT>`.

* **Port-forwarding**

    If Litmus is installed on a remote cluster (e.g. AKS), you can also just port-forward to access the UI locally:

    ```sh
    # The UI will then be accessible at 127.0.0.1:9091
    kubectl port-forward svc/chaos-litmus-frontend-service 9091:9091
    ```

In either case, once accessed, the default Litmus credentials (as stated in the [docs]) are:

```
Username: admin
Password: litmus
```

[docs]: https://docs.litmuschaos.io/docs/getting-started/installation/#accessing-the-chaoscenter

## Install Chaos Experiments

After you've accessed the Litmus UI, but before you've run your first simulated workload, you must install the standard set of chaos experiments for your given version of litmus. See the following:

```sh
kubectl apply -f https://hub.litmuschaos.io/api/chaos/<YOUR_LITMUS_VERSION>?file=charts/generic/experiments.yaml -n litmus
```

## Running this simulated workload

There are two methods of running this simulated workload; via Litmus Chaos or via Argo Workflows (as they share Workflow YAML schemas). However, the preferred method of running this is via Litmus Chaos.

If you have any issues running the workload related to service accounts or permissions, try:

```sh
kubectl apply -f rbac.yaml
```

>Note: make sure you have also already applied any required `WorkflowTemplate`'s before running a scenario! For instance:
>
>`kubectl apply -f chaos-templates.yaml -n litmus`
### To run the simulated workload with Litmus Chaos:

In the Litmus Chaos UI, click "Schedule a Chaos Scenario":

![Run with Litmus Chaos](/assets/litmus-launch-scenario.png)

Upload the `simulated-workload-poc.yaml` Chaos Scenario and watch it run in the UI. Also it's recommended to check on the pods in both the "default" and "litmus" namespaces as it runs.

### To run the simulated workload with Argo Workflows

First ensure you have [Argo Workflows installed on your cluster] and that you have the [argo CLI tool installed]. Then run:

[Argo Workflows installed on your cluster]: https://argoproj.github.io/argo-workflows/quick-start/#install-argo-workflows
[argo CLI tool installed]: https://argoproj.github.io/argo-workflows/quick-start/#install-the-argo-workflows-cli

```sh
argo submit --watch ./simulated-workload-poc.yaml
```

As this runs, you'll be able to follow along both in the terminal as well as in the Argo WF UI.
