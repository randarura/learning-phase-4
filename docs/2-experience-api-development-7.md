# Experience API Development Basics #2-6

## Deploy to Vercel

**Open Vercel Site**

1. Open URL `https://vercel.com/{{your-team}}/learning-phase-4`
2. Click `Settings`
3. Build Command -> Override -> ON

![Vercel](./images/2/23.png)

4. Enter `prisma generate && next build`
5. Click `Save` button

![Vercel](./images/2/24.png)

**Commit & Push to GitHub**

1. Click on Source Control

![Vercel](./images/2/25.png)

2. Click on Stage Changes

![Vercel](./images/2/26.png)

3. Enter commit message
4. Click Commit button

![Vercel](./images/2/27.png)

5. Click Sync Changes button

![Visual Studio Code](./images/2/12.png)

**Vercel Site**

Open your Vercel page:

1. Click `Visit` button

![Visual Studio Code](./images/2/28.png)

2. Open URL: `https://{{your-project-url}}/api/pets`

![Visual Studio Code](./images/2/29.png)

Success!

## Test and Operation check

List of URL

- `api/pets`
- `api/pets/1`
- `api/pets/1/weights`

Open file: [`request.http`](../request.http)

Edit the following code to your `request.http`:

```ts
@baseUrl = https://{{your-project-url}}/api

GET {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

###
```

Run:

- Click `Send Request`
- Open Respons Tab

Is it working correctly?

Now it's complete.

Thank you for your hard work!

An extra

Next [`Experience API Development Basics #3`](./3-experience-front-development-1.md)
