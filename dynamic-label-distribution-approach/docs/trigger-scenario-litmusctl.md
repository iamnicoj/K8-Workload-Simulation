
## manual script example

The following scripts helps cleaning and resetting the litmus scenario run and the target apps namespace

```bash
# check if port is correct
litmusctl config set-account --endpoint="http://127.0.0.1:9197/" --username="admin" --password="litmus" 

# litmusctl get projects

DEFAULT_PROJECT=$(litmusctl get projects |  awk '$1  ~ /[({]?[a-fA-F0-9]{8}[-]?([a-fA-F0-9]{4}[-]?){3}[a-fA-F0-9]{12}[})]?/'  | awk '{ print $1 }' |  awk 'NR>1{exit};1')

# print the available chaos-scenaios - We should filter those that are running only maybe
DELEGATE_ID=$(litmusctl get   chaos-delegates --project-id=$DEFAULT_PROJECT |  awk '$1  ~ /[({]?[a-fA-F0-9]{8}[-]?([a-fA-F0-9]{4}[-]?){3}[a-fA-F0-9]{12}[})]?/'  | awk '{ print $1 }' |  awk 'NR>1{exit};1')

litmusctl create chaos-scenario -f basic-workload-poc.yaml --project-id=$DEFAULT_PROJECT --chaos-delegate-id=$DELEGATE_ID
```

Installation

```bash
make
cd platforms-0.15.0
tar -zxvf litmusctl-darwin-amd64-0.15.0.tar.gz
chmod +x litmusctl
mv litmusctl /usr/local/bin/litmusctl
cd ..
```
