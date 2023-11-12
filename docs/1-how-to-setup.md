# How to setup

Download and install the application on your PC!

## Visual Studio Code

[https://code.visualstudio.com/](https://code.visualstudio.com/)

Download `Visual Studio Code` for your platform:
![Visual Studio Code](./images/1/1.png)

![Visual Studio Code](./images/1/2.png)

## Node.js

[https://nodejs.org/en](https://nodejs.org/en)

Download `20.9.0 LTS` for your platform:
![Node.js](./images/1/4.png)

### Confirmation that installation is complete

Launch `Visual Studio Code`  
Open terminal:
![Visual Studio Code](./images/1/3.png)
Type `node -v` in the terminal

```bash
node -v
```

If you see "v20.9.0", it is OK.
![Node.js](./images/1/5.png)

## Git

[https://git-scm.com/](https://git-scm.com/)

Download `Git` for your platform:  
For Mac user - git is already installed
![Visual Studio Code](./images/1/8.png)

Close and re-open terminal:
![Visual Studio Code](./images/1/3.png)
Type `git --version` in the terminal

```bash
git --version
```

If you see "git version X.XX.X(ex. 2.30.1)", Any version is OK
![Git](./images/1/6.png)

If you see the screen below, choose Install
![Git](./images/1/7.png)
After installation, close and re-open the terminal

## GitHub

Create your account
![GitHub](./images/1/9.png)

SSHキー尊くとか

After creation, open the following URL
[https://github.com/GuildWorks/learning-phase-4](https://github.com/GuildWorks/learning-phase-4)

ダウンロードしてくるところとか

フォークさせる方がよいかも
権限とかデプロイさせるために

npm install
npm run dev して起動するのを確認するところまで

## Vercel

githubと連携させてデプロイさせる
ストレージも作成して接続させる

参考
https://vercel.com/guides/nextjs-prisma-postgres#step-2-set-up-your-vercel-postgres-database

どこかでVS Codeの拡張を入れるのもやっておきたい
extensions.json に指定しているもの

```
❯ vercel link
Vercel CLI 32.5.3
? Set up “~/Study/learning-phase-4”? [Y/n] y
? Which scope should contain your project? total-pbc
? Found project “total-pbc/learning-phase-4”. Link to it? [Y/n] y
✅  Linked to total-pbc/learning-phase-4 (created .vercel)
❯ vercel env pull .env.development.local
Vercel CLI 32.5.3
> Downloading `development` Environment Variables for Project learning-phase-4
✅  Created .env.development.local file  [157ms]
```

vercel env pull .env.development.local

これだと動かないので、

vercel env pull .env

がよさそう
