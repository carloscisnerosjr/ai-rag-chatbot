# AI RAG Chatbot Guide

This is based on the starter project for the Vercel AI SDK [Retrieval-Augmented Generation (RAG) guide](https://sdk.vercel.ai/docs/guides/rag-chatbot). I have edited parts of the stack for an easier setup. Choose the script based on your OS below. MacOS and Windows are currently supported.

## Stack

- [Next.js](https://nextjs.org) 14 (App Router)
- [Vercel AI SDK](https://sdk.vercel.ai/docs)
- [OpenAI](https://openai.com)
- [Drizzle ORM](https://orm.drizzle.team)
- [Postgres Docker Image](https://hub.docker.com/r/supabase/postgres)
- [shadcn-ui](https://ui.shadcn.com) and [TailwindCSS](https://tailwindcss.com)

## Prerequisites

Be sure to have an OpenAI API key, Git and pnpm installed.
- OpenAI API Key
- Git 
- pnpm (`brew install pnpm` or `choco install pnpm`)

## Clone the Repository, install dependencies and create .env file

`git clone https://github.com/carloscisnerosjr/ai-rag-chatbot`

Run `pnpm install` to install the dependencies.

Rename `.env.example` to `.env` and add your OpenAI API key. Keep the database URL as is.

## Run the Setup Script

Run the setup script at the root of the repository based on your OS.

MacOS

- In Terminal, run `bash setup.sh`.

> You may need to accept incoming networking connections on a Mac when running the script.

Windows

- Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force` on Windows to allow the script to run.   
- In Powershell, run `./setup.ps1`.

The server and database will start automatically after the script finishes. Navigate to http://localhost:3000 to view the chatbot and to https://local.drizzle.studio to view the database. 

## Chat with the Bot and verify empty knowledge base

Navigate to http://localhost:3000. Ask the chatbot it knows your favorite food. It will not know the answer because it is not trained on that data!

How can we integrate a knowledge base that the chatbot can use?

## Verify database is empty

Navigate to https://local.drizzle.studio in your browser to view the database. Notice that the embeddings table is empty. The bot does not have any knowledge of your favorite food!

## Add to the bot's knowledge base

Tell the bot your favorite food. Check the database again and there should now be a row with data about your favorite food! Your first embedding is stored in the database!

Ask the bot your favorite food again. It should now know the answer! Congrats, you've just added to the bot's knowledge base using embeddings and built your first RAG chatbot!

## Stop the server and database studio

- Run `pnpm stop` to stop the server. 
- Run `pnpm db:studio:stop` to stop the database studio. 
- Run `docker compose down -v --rmi all` to remove the Docker container.
- Remove your API key from the `.env` file.

