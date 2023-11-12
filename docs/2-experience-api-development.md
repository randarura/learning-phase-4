# Experience API Development Basics

## Connect to the database

### 1. Settings for connecting to the database you created

Open file: [prisma/schema.prisma](../prisma/schema.prisma)

`schema.prisma` so that it looks like this:

```ts
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url = env("POSTGRES_PRISMA_URL") // uses connection pooling
  directUrl = env("POSTGRES_URL_NON_POOLING") // uses a direct connection
}
```

### 2. The model definitions

Pet model learned in learning phase #1 and #2

#### User

```ts
model User {
  id            Int       @id @default(autoincrement())
  email         String    @unique
  name          String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  pets          Pet[]
}
```

#### Pet

```ts
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
}
```

Explanation:

```ts
// number
// ex) 1, 2, 3
Int

// text
// ex) kim, kyogoku, imahashi
String

// Date & time
// ex)
DateTime
```

```ts
// autoincrement id ex) 1, 2, 3, ...
@id @default(autoincrement()

// unique email
@unique

// Register Current Date & Time
@default(now())

// Relationship User
// Here, "Owner" is used as an item that refers to the User model
@relation(fields: [ownerId], references: [id])

// User can have multiple pets
// pets plural
// Pet[] array
pets Pet[]
```

Add the following model definitions to your `schema.prisma` so that it looks like this:

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

+model User {
+ id            Int       @id @default(autoincrement())
+ email         String    @unique
+ name          String?
+ createdAt     DateTime  @default(now())
+ updatedAt     DateTime  @updatedAt
+ pets          Pet[]
+}

+model Pet {
+ id            Int       @id @default(autoincrement())
+ name          String
+ imageUrl      String?
+ birthDate     DateTime?
+ gender        String?
+ createdAt     DateTime  @default(now())
+ updatedAt     DateTime  @updatedAt
+ owner         User?     @relation(fields: [ownerId], references: [id])
+ ownerId       Int?
+}
```

After

```ts
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
}
```

Because Prisma Client is tailored to your own schema, you need to update it every time your Prisma schema file is changing by running the following command:

```bash
npx prisma generate
```

#### If you succeed

```bash
$ npx prisma generate
Prisma schema loaded from prisma/schema.prisma

✔ Generated Prisma Client (v5.5.2) to ./node_modules/@prisma/client in 41ms

Start using Prisma Client in Node.js (See: https://pris.ly/d/client)

import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

or start using Prisma Client at the edge (See: https://pris.ly/d/accelerate)

import { PrismaClient } from '@prisma/client/edge'
const prisma = new PrismaClient()

See other ways of importing Prisma Client: http://pris.ly/d/importing-client
```

Run the following command to create your database.  
This also creates the `User` and `Pet` tables that are defined in [`prisma/schema.prisma`](../prisma/schema.prisma):

```bash
npx prisma migrate dev --name init
```

When `npx prisma migrate dev` is executed against a newly created database, seeding is also triggered.  
The seed file in [`prisma/seed.ts`](../prisma/seed.ts) will be executed and your database will be populated with the sample data.

#### If you succeed

```bash
$ npx prisma migrate dev --name init
Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": PostgreSQL database "verceldb", schema "public" at "ep-steep-union-55122613.us-east-1.postgres.vercel-storage.com"

Applying migration `20231112100110_init`

The following migration(s) have been created and applied from new schema changes:

migrations/
  └─ 20231112100110_init/
    └─ migration.sql

Your database is now in sync with your schema.

✔ Generated Prisma Client (v5.5.2) to ./node_modules/@prisma/client in 48ms

Running seed command `ts-node prisma/seed.ts` ...
Start seeding ...
{
  alice: {
    id: 1,
    email: 'alice@pbc.io',
    name: 'Alice',
    createdAt: 2023-11-12T10:22:08.277Z,
    updatedAt: 2023-11-12T10:22:08.277Z
  },
  bob: {
    id: 2,
    email: 'bob@pbc.io',
    name: 'Bob',
    createdAt: 2023-11-12T10:22:10.428Z,
    updatedAt: 2023-11-12T10:22:10.428Z
  }
}
Seeding finished.

🌱  The seed command has been executed.
```
