# Experience API Development Basics #2-5

## API implementations

### 15. Summary of CRUD

**Define API operations in terms of HTTP methods**

| Resource | POST(Create)     | GET(Read)                      | PUT(Update)                              | DELETE(Delete)  |
| -------- | ---------------- | ------------------------------ | ---------------------------------------- | --------------- |
| /pets    | Create a new pet | Retrieve all pets              | Bulk update of pets                      | Remove all pets |
| /pets/1  | Error            | Retrieve the details for pet 1 | Update the details of pet 1 if it exists | Remove pet 1    |

`C`reate, `R`ead, `U`pdate, `D`ELETE

All CRUD have been completed!

**Logic support, etc. next time #5**

### 16. Troubleshooting

If an error occurs with the prisma command.

```bash
npx prisma generate
```

### 17. Add Model

Add weight model

**Weight**

```ts
model Weight {
  id            Int       @id @default(autoincrement())
  weight        Float
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  pet           Pet       @relation(fields: [petId], references: [id])
  petId         Int
}
```

Relation to pets is required.

Add the following to pet model.

```ts
weights       Weight[]
```

Diff

```diff
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url = env("POSTGRES_PRISMA_URL") // uses connection pooling
  directUrl = env("POSTGRES_URL_NON_POOLING") // uses a direct connection
}

model User {
  id            Int       @id @default(autoincrement())
  email         String    @unique
  name          String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  pets          Pet[]
}

model Pet {
  id            Int       @id @default(autoincrement())
  name          String
  imageUrl      String?
  birthDate     DateTime?
  gender        String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  owner         User?     @relation(fields: [ownerId], references: [id])
  ownerId       Int?
+ weights       Weight[]
}

+model Weight {
+  id            Int       @id @default(autoincrement())
+  weight        Float
+  createdAt     DateTime  @default(now())
+  updatedAt     DateTime  @updatedAt
+  pet           Pet       @relation(fields: [petId], references: [id])
+  petId         Int
+}
```

Run the following command to add model your database.  
This also create the `Weight` and update the `Pet` tables that are defined in [`prisma/schema.prisma`](../prisma/schema.prisma):

```bash
npx prisma migrate dev --name add-weight-model
```

```bash
$ npx prisma migrate dev --name add-weight-model
Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": PostgreSQL database "verceldb", schema "public" at "ep-steep-union-55122613.us-east-1.postgres.vercel-storage.com"

Applying migration `20231116044813_add_weight_model`

The following migration(s) have been created and applied from new schema changes:

migrations/
  └─ 20231116044813_add_weight_model/
    └─ migration.sql

Your database is now in sync with your schema.

✔ Generated Prisma Client (v5.6.0) to ./node_modules/@prisma/client in 54ms
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)

```diff
All Models
  Pet        2
  User       2
+ Weight     0
```

Added weight model!

> [TIPS]
> Reboot if you don't see it.

### 18. Create the weight if it pet exists

| Resource        | PST(Create)                          |
| --------------- | ------------------------------------ |
| /pets/1/weights | Create the weight if it pet 1 exists |

Add file: [`src/app/api/pets/[id]/weights/route.ts`](../src/app/api/pets/[id]/weights/route.ts)

1. Click [id] folder
2. Click New File...
3. Enter `weights/route.ts`

Created file: [`src/app/api/pets/[id]/weights/route.ts`](../src/app/api/pets/[id]/weights/route.ts)

like this:

```bash
src
├── app
│   ├── api
│   │   └── pets
│   │       ├── [id]
│   │       │   ├── weights
│   │       │   │   └── route.ts
│   │       │   └── route.ts
│   │       └── route.ts
```

Open file: [`src/app/api/pets/[id]/weights/route.ts`](../src/app/api/pets/[id]/weights/route.ts)

Enter the following code to your `route.ts`:

```ts
import { NextResponse } from 'next/server'

import prisma from '../../../../../../lib/prisma'

// POST /api/pets/:id/weights
export async function POST(request: Request, { params }: { params: { id: string } }) {
  // get id from params
  const id = params.id
  // get data from request body
  const data = await request.json()
  // create weight record
  const weight = await prisma.weight.create({
    // data from request body
    data: data.weight,
  })
  // return Response with weight to json
  return NextResponse.json({ weight })
}
```

Open file: [`request.http`](../request.http)

Enter the following code to your `request.http`:  
Add to the bottom.

```ts
POST {{baseUrl}}/pets/1/weights HTTP/1.1
Content-Type: application/json

{
  "weight": {
    "weight": 10.0,
    "petId": 1
  }
}
```

**Explanation of Code**

Same as pet Create, just with different tables.

```ts
// create weight record
const weight = await prisma.weight.create({
  // data from request body
  data: data.weight,
})
```

Run POST Method:

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
POST {{baseUrl}}/pets/1/weights HTTP/1.1
Content-Type: application/json

{
  "weight": {
    "weight": 10.0,
    "petId": 1
  }
}
```

Result

```json
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Thu, 16 Nov 2023 06:01:28 GMT
Connection: close
Transfer-Encoding: chunked

{
  "weight": {
    "id": 1,
    "weight": 10,
    "createdAt": "2023-11-16T06:01:26.299Z",
    "updatedAt": "2023-11-16T06:01:26.299Z",
    "petId": 1
  }
}
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)
2. Click Pet table

Created weight record!

### 19. Retrieve the details for pet 1

| Resource | GET(Read)                      |
| -------- | ------------------------------ |
| /pets/1  | Retrieve the details for pet 1 |

**Why not `/pets/1/weight`?**

It should be possible to get it with the details of `/pets/1`.

Open file: [`src/app/api/pets/[id]/route.ts`](../src/app/api/pets/[id]/route.ts)

Enter the following code to your `route.ts`:

```ts
// GET /api/pets/:id
export async function GET(request: Request, { params }: { params: { id: string } }) {
  // get id from params
  const id = params.id
  // findUnique returns a single pet with owner data
  const pet = await prisma.pet.findUnique({
    // where id is equal to the id param
    where: { id: Number(id) },
    // include owner data
    include: { owner: true, weights: true },
  })
  // return Response with pets to json
  return NextResponse.json({ pet })
}
```

**Explanation of Code**

Simply add `weights: true`

```ts
const pet = await prisma.pet.findUnique({
  ...
  // include owner data
  include: { owner: true, weights: true },
})
```

Run GET Method:

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
GET {{baseUrl}}/pets/1 HTTP/1.1
Content-Type: application/json
```

Result

```ts
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Thu, 16 Nov 2023 07:26:08 GMT
Connection: close
Transfer-Encoding: chunked

{
  "pet": {
    "id": 1,
    "name": "JIJI",
    "imageUrl": "https://cdn2.thecatapi.com/images/9u1.jpg",
    "birthDate": "2022-01-01T00:00:00.000Z",
    "gender": "Male",
    "createdAt": "2023-11-16T02:02:55.921Z",
    "updatedAt": "2023-11-16T02:02:55.921Z",
    "ownerId": 1,
    "owner": {
      "id": 1,
      "email": "alice@pbc.io",
      "name": "Alice",
      "createdAt": "2023-11-16T02:02:55.921Z",
      "updatedAt": "2023-11-16T02:02:55.921Z"
    },
    "weights": [
      {
        "id": 1,
        "weight": 10,
        "createdAt": "2023-11-16T06:01:26.299Z",
        "updatedAt": "2023-11-16T06:01:26.299Z",
        "petId": 1
      }
    ]
  }
}
```

Finally, deploy to Vercel.

Next [`Experience API Development Basics #2-6`](./2-experience-api-development-7.md)
