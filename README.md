# Mounting Party

A demonstration project showing how to mount remote cloud storage buckets (AWS S3, Google Cloud Storage, and Cloudflare R2) into a [Cloudflare Container](https://developers.cloudflare.com/containers/) using FUSE filesystem.

This project uses [TigrisFS](https://github.com/tigrisdata/tigrisfs) to mount S3-compatible buckets and [Copyparty](https://github.com/9001/copyparty) as a web-based file manager to browse and manage the mounted files.

![Demo](./demo.gif)

## Overview

The project consists of:

- A **Cloudflare Worker** that routes requests to a container
- A **Container** running Debian with TigrisFS and Copyparty
- **TigrisFS** for mounting S3-compatible storage (R2, S3, GCS) via FUSE
- **Copyparty** as a web interface for file management

## Prerequisites

### 1. Docker

You must have Docker running locally when deploying. Install [Docker Desktop](https://docs.docker.com/desktop/) or use tools like [Colima](https://github.com/abiosoft/colima).

Verify Docker is running:

```bash
docker info
```

### 2. Node.js

Ensure you have Node.js installed (v18+).

### 3. Cloudflare Account

You need a Cloudflare account with access to [Containers (Beta)](https://developers.cloudflare.com/containers/).

### 4. Cloud Storage Bucket

Create a bucket on your preferred S3-compatible storage provider:

- **Cloudflare R2**: [Create an R2 bucket](https://developers.cloudflare.com/r2/buckets/create-buckets/)
- **AWS S3**: [Create an S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-bucket.html)
- **Google Cloud Storage**: [Create a GCS bucket](https://cloud.google.com/storage/docs/creating-buckets) (with S3 interoperability)

## Setup

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/megaconfidence/mounting-party.git
cd mounting-party
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the project root with the following variables:

```env
# Your application domain (for copyparty CORS configuration)
APP_DOMAIN=https://your-worker.your-subdomain.workers.dev

# Cloudflare R2 Configuration
R2_ACCOUNT_ID=your_cloudflare_account_id
R2_BUCKET_NAME=your_bucket_name

# S3-compatible credentials (works with R2, S3, or GCS)
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

#### Getting Your Credentials

**For Cloudflare R2:**

1. Go to your [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Navigate to R2 > Overview
3. Your Account ID is in the URL or sidebar
4. Create an API token under R2 > Manage R2 API Tokens
5. Use the Access Key ID and Secret Access Key from the token

**For AWS S3:**

1. Go to AWS IAM Console
2. Create a new user with S3 access
3. Generate Access Keys
4. Update the endpoint in `startup.sh` to use S3's endpoint

**For Google Cloud Storage:**

1. Enable S3-compatible access in GCS
2. Create HMAC keys for your service account
3. Update the endpoint in `startup.sh` to use GCS's S3-compatible endpoint

### 3. Development

Run the development server:

```bash
npm run dev
```

Open [http://localhost:8787](http://localhost:8787) to see the Copyparty file manager interface.

> **Note:** Local development may not fully support container features. For full functionality, deploy to Cloudflare.

### 4. Deploy to Cloudflare

Deploy your `.env` secrets, Worker and Container:

```bash
# create worker scaffolding & deply secrets
npx wrangler secret bulk .env
# deploy worker & container
npm run deploy
```

When you run `wrangler deploy`:

1. Wrangler builds your container image using Docker
2. Wrangler pushes your image to Cloudflare's Container Image Registry
3. Wrangler deploys your Worker and configures the container

> **Note:** After the first deployment, wait several minutes for the container to be provisioned. During this time, requests to the Worker may error as the container boots up.

### 5. Check Deployment Status

View your deployed containers:

```bash
npx wrangler containers list
```

## Learn More

- [Cloudflare Containers Documentation](https://developers.cloudflare.com/containers/)
- [Container Class Repository](https://github.com/cloudflare/containers)
- [TigrisFS](https://github.com/tigrisdata/tigrisfs)
- [Copyparty](https://github.com/9001/copyparty)
- [Cloudflare R2 Documentation](https://developers.cloudflare.com/r2/)
