# Vercel AI SDK RAG Guide Starter Project

This is the starter project for the Vercel AI SDK [Retrieval-Augmented Generation (RAG) guide](https://sdk.vercel.ai/docs/guides/rag-chatbot).

## Stack

- [Next.js](https://nextjs.org) 14 (App Router)
- [Vercel AI SDK](https://sdk.vercel.ai/docs)
- [OpenAI](https://openai.com)
- [Drizzle ORM](https://orm.drizzle.team)
- [Postgres Docker Image](https://hub.docker.com/r/supabase/postgres)
- [shadcn-ui](https://ui.shadcn.com) and [TailwindCSS](https://tailwindcss.com)

## Prerequisites

- Docker
- OpenAI API Key
- Node.js

## Clone the Repository

`git clone https://github.com/carloscisnerosjr/ai-rag-chatbot`

Rename `.env.example` to `.env` and add your OpenAI API key. Keep the database URL as is.

## Run the Setup Script

Download the setup script based on your OS. Save it in the root of the repository.

- [Bash](./scripts/setup.sh)
- [PowerShell](./scripts/setup.ps1)

Run the script and the server will start automatically after the script finishes. Navigate to http://localhost:3000 to view the chatbot.

> Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force` on Windows to allow the script to run.        

## Chat with the Bot and verify empty knowledge base

Ask if it knows your favorite food. It will not know the answer. Is the information stored in the database? Let's find out.

Run `pnpm db:studio` to view the database. Navigate to local.drizzle.studio in your browser to view the database. Notice that the embeddings table is empty. The bot does not have any knowledge of your favorite food!

## Add to the bot's knowledge base

Tell the bot your favorite food. Check the database again and there should now be a row with data about your favorite food! Your first embedding is stored in the database!

Ask the bot your favorite food again. It should now know the answer! Congrats, you've just added to the bot's knowledge base using embeddings and built your first RAG chatbot!

## Stop the server and database studio

Run `pnpm stop` to stop the server. Run `pnpm db:studio:stop` to stop the database studio. Remove your API key from the `.env` file.


