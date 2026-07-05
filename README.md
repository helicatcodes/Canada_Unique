# Beyond Exchange
### The Canada Unique Journey

A web platform for German teenagers (14–16) preparing for their student exchange year with the exchange agency Canada Unique. Built by a team of four in two weeks, from pitch to demo day, during [Le Wagon](https://www.lewagon.com)'s AI Software Development bootcamp.

## The problem

Student exchange journeys are often let down by:

- **Fragmented communication** spread across emails, WhatsApp groups, and paper forms, shared unevenly between students, parents, and host families
- **No peer community**, leaving students to navigate homesickness and culture shock alone
- **Personal development left to chance**, with no structure to reflect on growth before, during, and after the exchange

## What Beyond Exchange does

Beyond Exchange structures the exchange journey, builds peer community, and centralizes communication in one place for students, parents, and host families. It's the first digital pedagogical framework that makes high-touch exchange support measurable and guided, rather than ad hoc.

- **Guided reflection** — structured questionnaires that prompt students to reflect on challenges, growth, and confidence at key points in their journey
- **Community feed** — students share photos and updates, and comment and like each other's posts
- **Tasks** — a checklist-style framework that gives structure to the exchange journey
- **Direct messaging & notifications** — centralized communication between students, parents, and host families
- **AI chatbot** — an in-app assistant for guidance and support
- **Role-based access** — separate views for students, admins, and parents/viewers

## Tech stack

- **Backend:** Ruby on Rails 8.1
- **Database:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), Bootstrap 5, importmap
- **Auth & authorization:** Devise, Pundit
- **AI:** [ruby_llm](https://github.com/crmne/ruby_llm) for the in-app chatbot
- **Media:** Cloudinary for image storage
- **Notifications:** Noticed
- **Background jobs & caching:** Solid Queue, Solid Cache, Solid Cable
- **Deployment:** Docker, Kamal

## Getting started

# install dependencies
bundle install

# set up the database
rails db:create db:migrate db:seed

# run the app
rails server

The app expects a `.env` file with credentials for Cloudinary and your LLM provider.

## Team

Built in a team of four during Le Wagon's AI Software Development bootcamp.
