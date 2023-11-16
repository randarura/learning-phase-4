# Experience API Development Basics #2-3

## API implementations

### 8. Bulk update of pets

| Resource | PUT(Update)         |
| -------- | ------------------- |
| /pets    | Bulk update of pets |

Open file: [`src/app/api/pets/route.ts`](../src/app/api/pets/route.ts)

Enter the following code to your `route.ts`:

```ts
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
```

Diff

```diff
import { NextResponse } from 'next/server'

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

+// PUT /api/pets
+export async function PUT(request: Request) {
+  // get data from request body
+  const data = await request.json()
+  // update pet record
+  const pets = await prisma.pet.updateMany({
+    // where gender is Male
+    where: { gender: 'Male' },
+    // data from request body
+    data: data.pet,
+  })
+  // return Response with pet to json
+  return NextResponse.json({ pets })
+}
```

**Explanation of Code**

PUT method is executed when `/api/pets` is accessed.

```ts
// PUT /api/pets
export async function PUT(request: Request) {
  ...
}
```

`updateMany` updates all gender of Male

```ts
// update pet record
const pets = await prisma.pet.updateMany({
  // where gender is Male
  where: { gender: 'Male' },
  // data from request body
  data: data.pet,
})
```

Open file: [`request.http`](../request.http)

Enter the following code to your `request.http`:

```ts
###

PUT {{baseUrl}}/pets HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "gender": "Female"
  }
}
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

+###
+
+PUT {{baseUrl}}/pets/ HTTP/1.1
+Content-Type: application/json
+
+{
+  "pet": {
+    "gender": "Female"
+  }
+}
```

Run PUT Method:

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
PUT {{baseUrl}}/pets/ HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "gender": "Female"
  }
}
```

Result

```json
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Wed, 15 Nov 2023 13:00:50 GMT
Connection: close
Transfer-Encoding: chunked

{
  "pets": {
    "count": 2
  }
}
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)
2. Click Pet table

`JIJI` and `MIAO` gender change `Female`...

Updateed pet records!

### 9. Update the details of pet 1 if it exists

| Resource | PUT(Update)                              |
| -------- | ---------------------------------------- |
| /pets/1  | Update the details of pet 1 if it exists |

Open file: [`src/app/api/pets/[id]/route.ts`](../src/app/api/pets/[id]/route.ts)

Enter the following code to your `route.ts`:

```ts
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

+// PUT /api/pets/:id
+export async function PUT(request: Request, { params }: { params: { id: string } }) {
+  // get id from params
+  const id = params.id
+  // get data from request body
+  const data = await request.json()
+  // update pet record
+  const pet = await prisma.pet.update({
+    // where id is equal to the id param
+    where: { id: Number(id) },
+    // data from request body
+    data: data.pet,
+  })
+  return NextResponse.json({ id: id })
+}
```

Open file: [`request.http`](../request.http)

Enter the following code to your `request.http`:

```ts
###

PUT {{baseUrl}}/pets/3 HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Luna"
  }
}
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

PUT {{baseUrl}}/pets/ HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "gender": "Female"
  }
}

+###
+
+PUT {{baseUrl}}/pets/3 HTTP/1.1
+Content-Type: application/json
+
+{
+  "pet": {
+    "name": "Luna"
+  }
+}
```

**Explanation of Code**

You already know that.

Update the name of the target id.

Run PUT Method:

- Click `Send Request`
- Open Respons Tab

```ts
Send Request
PUT {{baseUrl}}/pets/3 HTTP/1.1
Content-Type: application/json

{
  "pet": {
    "name": "Luna"
  }
}
```

Update pet record:

```json
HTTP/1.1 200 OK
vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url
content-type: application/json
Date: Wed, 15 Nov 2023 13:36:26 GMT
Connection: close
Transfer-Encoding: chunked

{
  "id": "3"
}
```

Check your database:

1. Open URL [http://localhost:5555/](http://localhost:5555/)
2. Click Pet table

`SNOW` name change `Luna`.

Updated pet record!

### 10. Upsert

Review seed data.

You can see it right now.

`upsert` means register if there is no target data, update if there is.

Below, register if there is target data, otherwise do nothing.

```ts
const alice = await prisma.user.upsert({
  where: { email: 'alice@pbc.io' },
  update: {},
  create: {
    email: 'alice@pbc.io',
    name: 'Alice',
    pets: {
      create: {
        name: 'JIJI',
        imageUrl: 'https://cdn2.thecatapi.com/images/9u1.jpg',
        birthDate: new Date('2022-01-01'),
        gender: 'Male',
      },
    },
  },
})
```

### Exercise

Try using upsert to register your data.

### 11. Summary of PUT methods

**`updateMany`**

`updateMany` updates a batch of existing database records in bulk and returns the number of updated records.

---

**`update`**

`update` updates an existing database record.

---

**`upsert`**

`upsert` does the following:

- If an existing database record satisfies the where condition, it updates that record
- If no database record satisfies the where condition, it creates a new database record

---

Next [`Experience API Development Basics #2-4`](./2-experience-api-development-5.md)
