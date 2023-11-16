# Experience API Development Basics #2-4

## API implementations

### 12. Remove all pets

| Resource | DELETE(Delete)  |
| -------- | --------------- |
| /pets    | Remove all pets |

Open file: [`src/app/api/pets/route.ts`](../src/app/api/pets/route.ts)

Enter the following code to your `route.ts`:

```ts
// DELETE /api/pets
export async function DELETE() {
  // delete all pets
  const pets = await prisma.pet.deleteMany()
  // return Response with pets to json
  return NextResponse.json({ pets })
}
```

Diff

```diff_ts
import { NextResponse } from 'next/server'
import { type NextRequest } from 'next/server'

import prisma from '../../../../lib/prisma'

// GET /api/pets
export async function GET() {
  const pets = await prisma.pet.findMany({
    // sort by id ascending
    orderBy: { id: 'asc' },
    // include owner data
    // include: { owner: true },
    // select only id, name, imageUrl, and owner.name
    select: { id: true, name: true, imageUrl: true, owner: { select: { name: true } } },
  })
  // return Response with pets to json
  return NextResponse.json({ pets })
}

// POST /api/pets
export async function POST(request: Request) {
  // get data from request body
  const data = await request.json()
  // create pet record
  const pet = await prisma.pet.create({
    // data from request body
    data: data.pet,
  })
  // return Response with pet to json
  return NextResponse.json({ pet })
}

// PUT /api/pets
export async function PUT(request: Request) {
  // get data from request body
  const data = await request.json()
  // update pet record
  const pets = await prisma.pet.updateMany({
    // where gender is Male
    where: { gender: 'Male' },
    // data from request body
    data: data.pet,
  })
  // return Response with pet to json
  return NextResponse.json({ pets })
}

+// DELETE /api/pets
+export async function DELETE() {
+  // delete all pets
+  const pets = await prisma.pet.deleteMany()
+  // return Response with pets to json
+  return NextResponse.json({ pets })
+}
```

Open file: [`request.http`](../request.http)

Enter the following code to your `request.http`:

```ts
###

DELETE {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json
```

Diff

```diff
@baseUrl = http://localhost:3000/api

GET {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

###

GET {{baseUrl}}/pets/1 HTTP/1.1
Content-Type: application/json

###

POST {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Fido",
    "imageUrl": "https://cdn2.thecatapi.com/images/xBR2jSIG7.jpg",
    "birthDate": "2020-01-01T00:00:00.000Z",
    "gender": "Female",
    "ownerId": 1
  }
}

###

PUT {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "gender": "Female"
  }
}

###

PUT {{baseUrl}}/pets/3 HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Luna"
  }
}

+###
+
+DELETE {{baseUrl}}/pets HTTP/1.1
+Content-Type: application/json
```

**Explanation of Code**

It's so simple.

All data is deleted, so there is no data to receive.

```ts
export async function DELETE() {
  ...
}
```

Run DELETE Method:

> [!CAUTION]
> Delete all data when executed

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
DELETE {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json
```

Result

```json
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Thu, 16 Nov 2023 01:43:17 GMT
Connection: close
Transfer-Encoding: chunked

{
  "pets": {
    "count": 4
  }
}
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)
2. Click Pet table

All pets gone...

Deleted pet records!

**Data recovery**

```bash
npx prisma migrate reset
```

> [!IMPORTANT]
> Pets are back!

### 13. Remove pet 1

| Resource | DELETE(Delete) |
| -------- | -------------- |
| /pets/1  | Remove pet 1   |

Open file: [`src/app/api/pets/[id]/route.ts`](../src/app/api/pets/[id]/route.ts)

Enter the following code to your `route.ts`:

```ts
// DELETE /api/pets/:id
export async function DELETE(request: Request, { params }: { params: { id: string } }) {
  // get id from params
  const id = params.id
  // delete pet record
  const pet = await prisma.pet.delete({
    // where id is equal to the id param
    where: { id: Number(id) },
  })
  return NextResponse.json({ id: id })
}
```

Diff

```diff
import { NextResponse } from 'next/server'

import prisma from '../../../../../lib/prisma'

// GET /api/pets/:id
export async function GET(request: Request, { params }: { params: { id: string } }) {
  // get id from params
  const id = params.id
  // findUnique returns a single pet with owner data
  const pet = await prisma.pet.findUnique({
    // where id is equal to the id param
    where: { id: Number(id) },
    // include owner data
    include: { owner: true },
  })
  // return Response with pets to json
  return NextResponse.json({ pet })
}

// PUT /api/pets/:id
export async function PUT(request: Request, { params }: { params: { id: string } }) {
  // get id from params
  const id = params.id
  // get data from request body
  const data = await request.json()
  // update pet record
  const pet = await prisma.pet.update({
    // where id is equal to the id param
    where: { id: Number(id) },
    // data from request body
    data: data.pet,
  })
  return NextResponse.json({ id: id })
}

+// DELETE /api/pets/:id
+export async function DELETE(request: Request, { params }: { params: { id: string } }) {
+  // get id from params
+  const id = params.id
+  // delete pet record
+  const pet = await prisma.pet.delete({
+    // where id is equal to the id param
+    where: { id: Number(id) },
+  })
+  return NextResponse.json({ id: id })
+}
```

Open file: [`request.http`](../request.http)

Enter the following code to your `request.http`:

```ts
###

DELETE {{baseUrl}}/pets/2 HTTP/1.1
Content-Type: application/json
```

Diff

```diff
@baseUrl = http://localhost:3000/api

GET {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

###

GET {{baseUrl}}/pets/1 HTTP/1.1
Content-Type: application/json

###

POST {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Fido",
    "imageUrl": "https://cdn2.thecatapi.com/images/xBR2jSIG7.jpg",
    "birthDate": "2020-01-01T00:00:00.000Z",
    "gender": "Female",
    "ownerId": 1
  }
}

###

PUT {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "gender": "Female"
  }
}

###

PUT {{baseUrl}}/pets/3 HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Luna"
  }
}

###

DELETE {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

+###
+
+DELETE {{baseUrl}}/pets/2 HTTP/1.1
+Content-Type: application/json
```

**Explanation of Code**

Get id from URL and delete target.

Run DELETE Method:

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
DELETE {{baseUrl}}/pets/2 HTTP/1.1
Content-Type: application/json
```

Result

```json
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Thu, 16 Nov 2023 04:09:15 GMT
Connection: close
Transfer-Encoding: chunked

{
  "id": "2"
}
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)
2. Click Pet table

Deleted pet record!

### 14. Summary of DELETE methods

**`deleteMany`**

`deleteMany` deletes multiple records in a transaction.

---

**`delete`**

`delete` deletes an existing database record. You can delete a record:

- By ID
- By a unique attribute

To delete records that match a certain criteria, use `deleteMany` with a filter.

---

Next [`Experience API Development Basics #2-5`](./2-experience-api-development-6.md)
