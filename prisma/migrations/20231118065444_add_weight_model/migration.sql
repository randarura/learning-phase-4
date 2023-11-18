/*
  Warnings:

  - Made the column `birthDate` on table `Pet` required. This step will fail if there are existing NULL values in that column.
  - Made the column `gender` on table `Pet` required. This step will fail if there are existing NULL values in that column.
  - Made the column `ownerId` on table `Pet` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Pet" DROP CONSTRAINT "Pet_ownerId_fkey";

-- AlterTable
ALTER TABLE "Pet" ALTER COLUMN "birthDate" SET NOT NULL,
ALTER COLUMN "gender" SET NOT NULL,
ALTER COLUMN "ownerId" SET NOT NULL;

-- CreateTable
CREATE TABLE "Weight" (
    "id" SERIAL NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "petId" INTEGER NOT NULL,

    CONSTRAINT "Weight_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Pet" ADD CONSTRAINT "Pet_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Weight" ADD CONSTRAINT "Weight_petId_fkey" FOREIGN KEY ("petId") REFERENCES "Pet"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
