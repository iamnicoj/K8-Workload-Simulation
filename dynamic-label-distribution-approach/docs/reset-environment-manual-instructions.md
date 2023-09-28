# Manual env reset 

## litmusctl installation 

To install the `litmusctl` follow [this](https://github.com/litmuschaos/litmusctl) instructions. So far we have been using the `0..13.0` and `0.14.0` versions using the `2.13` and `2.14` backend.
You can also follow basic instructions on how to use the `litmusctl` [here](https://github.com/litmuschaos/litmusctl/blob/master/Usage.md)

## manual script example

The following scripts helps cleaning and resetting the litmus scenario run and the target apps namespace

```bash
# check if port is correct
litmusctl config set-account --endpoint="http://127.0.0.1:9195/" --username="admin" --password="litmus" 

# litmusctl get projects

DEFAULT_PROJECT=$(litmusctl get projects |  awk '$1  ~ /[({]?[a-fA-F0-9]{8}[-]?([a-fA-F0-9]{4}[-]?){3}[a-fA-F0-9]{12}[})]?/'  | awk '{ print $1 }' |  awk 'NR>1{exit};1')

# print the available chaos-scenaios - We should filter those that are running only maybe
litmusctl get chaos-scenarios  --project-id=$DEFAULT_PROJECT

# this next line replaces LAST_SCENARIO with latest scenario id query on previews command
LAST_SCENARIO=$(litmusctl get chaos-scenarios  --project-id=$DEFAULT_PROJECT |  awk '$1  ~ /[({]?[a-fA-F0-9]{8}[-]?([a-fA-F0-9]{4}[-]?){3}[a-fA-F0-9]{12}[})]?/'  | awk '{ print $1 }' |  awk 'NR>1{exit};1')

# delete the latest scenario defined in LAST_SCENARIO
litmusctl delete chaos-scenario $LAST_SCENARIO --project-id=$DEFAULT_PROJECT

# delete all other ephemeral components 
k delete chaosengine --all -n litmus
k delete chaosresults --all -n litmus
k delete jobs --all -n litmus
k delete pod --field-selector 'status.phase=Succeeded' -n litmus
k delete pods --field-selector 'status.phase=Failed' -n litmus
k delete ns scenario-ns --force --grace-period=0 

# Reapply all argo templates
k delete workflowtemplates.argoproj.io --all

k apply -f ./chaos-templates -n litmus
```

## manually change labels while the scenario is running

if you want to manually play with labels to be attach to stressors apply different set of labels every few minutes. Update the namespace and labels based on your own testing.

```bash
kubectl label pods -l workloadId=small-interactive-ads -n nico  --overwrite stressor=60cpu
kubectl label pods -l workloadId=medium-interactive-ads -n nico  --overwrite stressor=20cpu
kubectl label pods -l workloadId=large-interactive-ads -n nico  --overwrite stressor=20cpu
kubectl label pods -l workloadId=x-large-interactive-ads -n nico  --overwrite stressor=20cpu
```

TODO: use something like kustomize to dynamically update image paths to harbor repository on 

> 2022/11/17 16:25:37 Error Creating Resource : ChaosEngine.litmuschaos.io 'pod-cpu-engine-smxqr' is invalid: spec.appinfo.appkind: Invalid value: 'pod': spec.appinfo.appkind in body should match '^(^$|deployment|statefulset|daemonset|deploymentconfig|rollout)$'

## Known issues

Know issue getting this error in docker desktop: 
>Lab 4.6 Install crictl : issue with starting crio.service

Make sure you configure the `container_runtime` and the `socket_path` to run with the DD compliant framework

Anyway there will be issues running the cgroup error that I haven't figured it out just yet.

Additionally, running the scenario that deployes dozens of pods on small cluster can cause race conditions where stressor hogs fails randomly.