# README

Backend for the recover app.

Landingpage: recoverapp.de frontend-repository: github.com/railslove/rcvr-app
app: rcvr.app

## Development

### Secrets

We do not use rails credentials in favor of dotenv. You can find the variables
that you might want to set in the `.env` file.

### Setup

You can use the provided docker-compose file to locally run redis and postgres,
but it is not required.

### Primary Keys Integer IDs & UUIDs

**Attention!** We messed a little bit up here! Some models like the company
model uses uuids as primary keys. We did this because we expose these ids
through apis and wanted to haven them non predicatable. Other models are using
simple integer ids.

Unfortunately this leads to problems when using active storage: UUIDs are needed
as primary keys for models that uses active storage functionality. Because
active storage can't mixed use int and uuid primary keys.

We're thinking about a migration path on this to unify the usage of ids to uuids
order int ids.

### Stripe

Dont forget to set all four stripe related environment variables (see .env). For
trying out payment related things you might want to setup webhooks to work
locally with stripe (similar to ngrok), if your server runs on `localhost:3000`:

`stripe listen --forward-to localhost:3000/stripe-webhooks`

And to trigger test events:

`stripe trigger customer.subscription.updated`
