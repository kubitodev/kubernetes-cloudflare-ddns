# Kubernetes Cloudflare DDNS

This is a simple Kubernetes cronjob which can be used for updating a DNS record on Cloudflare.

## Installing with Helm

There is a helm chart available as well. Check [the ArtifactHub page](https://artifacthub.io/packages/helm/kubitodev/kubernetes-cloudflare-ddns) for more details.

## Installing with `kubectl`

* Replace the name of the `.env.example` file in this repository to `.env`.

* Login to Cloudflare and [create an API key](https://dash.cloudflare.com/profile/api-tokens) for your domain on Cloudflare with the following settings:

```txt
Token Name: `Edit Zone DNS`.
Permissions: `Zone -> DNS -> Edit`.
Zone Resources: `Include -> All zones`.
Client API Filtering can be left as default.
TTL can be left as default.
```

Now replace `AUTH_KEY` in `.env` with the key you just generated.

* Go to the overview tab on Cloudflare for your domain and copy the `Zone ID` key, and then replace `ZONE_ID` in `.env` with the value.

* Now you need to get the record ID for the `A` record that you wish to update. To do so, just execute the following command where you will replace the variables with your own:

```bash
export ZONE_ID=<YOUR_ZONE_ID>
export AUTH_KEY=<YOUR_API_KEY>

curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A" \
     -H "X-Auth-Email: your@email.com" \
     -H "Authorization: Bearer $AUTH_KEY" \
     -H "Content-Type: application/json"
```

You will get a JSON object returned, and you can use a prettifier or something to get a better look at it if you wish. When you see the record that you want, copy the `id` field value and replace `RECORD_ID` in the `.env` file with it.

* Replace the `NAME` value in `.env` with your domain or subdomain.


* Create the Kubernetes secret in your cluster:

```bash
kubectl create secret generic cloudflare-ddns --type=Opaque --dry-run=client --from-env-file=.env
```

* Review the `manifests/cronjob.yaml` file and edit it if you wish, and then apply it:

```bash
kubectl apply -f manifests/cronjob.yaml
```

## License

Copyright &copy; 2022 Kubito

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
