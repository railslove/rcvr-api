<p align="center">
  <img src="https://raw.githubusercontent.com/railslove/rcvr-app/master/.github/checkmark.png" width="95" height="87" alt="">
</p>

<h1 align="center">rcvr.app</h1>

<p align="center">
  Backend for the <a href="https://www.recoverapp.de">recoverapp.de</a>. You can find the client app here <a href="https://github.com/railslove/rcvr-app">github.com/railslove/rcvr-app</a> – a product by <a href="https://railslove.com">Railslove</a>
</p>

- [Intro](#intro)
- [How does rcvr.app work?](#how-does-rcvrapp-work)
- [Background](#background)
- [Contribute](#contribute)
- [License](#license)

# Recoverapp: Backlog

<a href="https://github.com/railslove/recover-backlog/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/railslove/recover-backlog"></a>

## Intro

Due to COVID-19, many localities, like bars and restaurants, must keep track of their guest. So, in the case of infection, the public health department can trace contact persons using this data.

The German government suggested a very old-school way on how to achieve this. Owners should put a printed document on each table, and guests have to write down their data with a pen, visible to everyone.

**We know we can do better.** Those lists are annoying for everyone, and especially a big privacy concern.

With **recover**, guests scan a QR Code with their phone and enter their contact details, which will be encrypted on their device and stored on our server. Only the business owner can decrypt this data, and only when the public health department requests it.

## How does recoverapp.de work?

When an owner signs up, a key pair will be generated on their device. The owner needs to safely store the private key by saving it inside a password manager or writing it on a piece of paper and putting it in a physical safe. This private key is required to decrypt the data of the guests.

The public part of this key pair is embedded inside the QR Code, together with a unique identifier for each table.

When the public health department requests data for a specific time range from an owner, we will send them the guest's encrypted data from this period. The owner can then decrypt this data using his private key and send it to the public health department.

When a guest checks in, a random ID will be saved on the guest's device. **recover** will provide a public feed of all check-in IDs in danger of a COVID-19 infection. The IDs can be public because they cannot be traced back to a person. Only the guest's device knows if one of the stored IDs is also inside this public feed. If this is the case, we can notify the guest of the potential infection.

## Background

**recover** was initially developed during one weekend. We noticed the urgency and needs of business owners and wanted to provide a solution. A special thanks goes to everyone who helped and consulted us to achieve our goal in this short amount of time.

## Development Setup

To get a development environment up and running ensure your development system has the following components:

- [docker](https://docs.docker.com/engine/install/)
- docker-compose
- ruby 2.7
- bundler (for ruby)
- basic C build tools (base-devel, build-essential or whatever your system calls these)
- eventually: postgres development headers

Then execute:

```
bundler
echo "DATABASE_URL=postgres://postgres:mysecretpassword@127.0.0.1:5432/" >> .env.local
docker-compose up -d # will start database in the background
rails db:setup RAILS_ENV=development
rails server
```

The example above uses a docker-compose file to locally run redis and postgres, but it is not required. Alternatively use your own setup.

Install rcvr-app frontend: https://github.com/railslove/rcvr-app

Create a frontend entry in your postgres database:

```
docker-compose exec postgres psql -U postgres`
postgres=# insert into frontends (name, url) values('App-Local', 'http://localhost:3333');
```

Your port might vary depending on your set up (see rcvr-app README).

### Deployment

- `origin/master` deploys to production on push
- All pushed branches will create a preview deployment

### Secrets

We do not use rails credentials in favor of dotenv. You can find the variables that you might want to set in the `.env` file.

### Stripe

Dont forget to set all four stripe related environment variables (see .env).
For trying out payment related things you might want to setup webhooks to work locally with stripe (similar to ngrok), if your server runs on `localhost:3000`:

`stripe listen --forward-to localhost:3000/stripe-webhooks`

And to trigger test events:

`stripe trigger customer.subscription.updated`

## License

**rcvr.api** is open-source and free software released under the [GNU AGPL](https://github.com/railslove/rcvr-api/blob/master/LICENSE) (GNU Affero General Public License v3.0). We, [Railslove GmbH](https://railslove.com/), are committed to ensuring that it will remain a free and open-source project.

---

<p align="center">
  Made with 💚 in Cologne
</p>
