# Vercel AI SDK RAG Guide Starter Project

This is the starter project for the Vercel AI SDK [Retrieval-Augmented Generation (RAG) guide](https://sdk.vercel.ai/docs/guides/rag-chatbot).

## Stack

- [Next.js](https://nextjs.org) 14 (App Router)
- [Vercel AI SDK](https://sdk.vercel.ai/docs)
- [OpenAI](https://openai.com)
- [Drizzle ORM](https://orm.drizzle.team)
- [Postgres](https://www.postgresql.org/) with [pgvector](https://github.com/pgvector/pgvector)
- [shadcn-ui](https://ui.shadcn.com) and [TailwindCSS](https://tailwindcss.com)

## Prerequisites

- Docker
- OpenAI API Key
- Node.js

## Setup

1. Clone the repository:

git clone https://github.com/carloscisnerosjr/ai-rag-chatbot

2. Run the setup script based on your OS. 

- [Bash](./scripts/setup.sh)
- [PowerShell](./scripts/setup.ps1)

The server will start automatically after the script finishes. Navigate to http://localhost:3000 to view the chatbot.

4. Chat with the bot. 

Ask it if it knows your favorite food. It will not know the answer.

5. Is the information stored in the database? Let's find out.

pnpm db:studio

Navigate to local.drizzle.studio to view the database.

Notice that the resources table is empty.

5. Add a new food to the bot's knowledge base and check the database again.

Tell the bot your favorite food. There should be a row in the resources table now.

6. Ask the bot your favorite food again. It should now know the answer.
