# Kubernetes Cloudflare DDNS

This is a simple Kubernetes cronjob which can be used for updating a DNS record on Cloudflare. To get started, you need to do the following:

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

## Installing with `kubectl`

* Create the Kubernetes secret in your cluster:

```bash
kubectl create secret generic cloudflare-ddns --type=Opaque --dry-run=client --from-env-file=.env
```

* Review the `manifests/cronjob.yaml` file and edit it if you wish, and then apply it:

```bash
kubectl apply -f manifests/cronjob.yaml
```

## Installing with Helm

There is a helm chart available as well. To use it, simply open `charts/kubernetes-cloudflare-ddns/values.yaml` and replace the secret values with your own, and replace anything else that you want. Then run:

```bash
helm install kubernetes-cloudflare-ddns --namespace cloudflare-ddns --create-namespace charts/kubernetes-cloudflare-ddns
```
