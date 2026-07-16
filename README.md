# Beyond Exchange
### The Canada Unique Journey

A web platform for German teenagers (14–16) preparing for their student exchange year with the exchange agency Canada Unique. Built by a team of four in two weeks, from pitch to demo day, during [Le Wagon's](https://www.lewagon.com) AI Software Development bootcamp.

## The problem

Student exchange journeys are often let down by:

- **Fragmented communication** spread across emails, WhatsApp groups, and paper forms, shared unevenly between students, parents, and host families
- **No peer community**, leaving students to navigate homesickness and culture shock alone
- **Personal development left to chance**, with no structure to reflect on growth before, during, and after the exchange

## What Beyond Exchange does

Beyond Exchange structures the exchange journey, builds peer community, and centralizes communication in one place for students, parents, and host families. It's the first digital pedagogical framework that makes high-touch exchange support measurable and guided, rather than ad hoc.

<table>
  <tr>
    <td width="25%" valign="top">
      <a href="https://github.com/user-attachments/assets/8dd108f9-e7fc-48b7-9337-fb3bfdbd7fe1">
        <img src="https://github.com/user-attachments/assets/8dd108f9-e7fc-48b7-9337-fb3bfdbd7fe1" alt="Home screen" width="100%">
      </a>
      <br><sub><b>Home</b><br>Your cohort, your moments, one tap away.</sub>
    </td>
    <td width="25%" valign="top">
      <a href="https://github.com/user-attachments/assets/20d8ab18-d0a1-4321-9e47-090bdcb941f5">
        <img src="https://github.com/user-attachments/assets/20d8ab18-d0a1-4321-9e47-090bdcb941f5" alt="Countdown until departure" width="100%">
      </a>
      <br><sub><b>Before you go</b><br>Countdown and prep tasks so nothing gets missed.</sub>
    </td>
    <td width="25%" valign="top">
      <a href="https://github.com/user-attachments/assets/83b6c9c5-4088-4f15-9980-c5fb6ac060a6">
        <img src="https://github.com/user-attachments/assets/83b6c9c5-4088-4f15-9980-c5fb6ac060a6" alt="Chat with Lucy, the AI coach" width="100%">
      </a>
      <br><sub><b>Lucy, your AI coach</b><br>Someone to ask at 2am when the paperwork is overwhelming.</sub>
    </td>
    <td width="25%" valign="top">
      <a href="https://github.com/user-attachments/assets/be745989-2671-4d36-910c-6f69a49430c9">
        <img src="https://github.com/user-attachments/assets/be745989-2671-4d36-910c-6f69a49430c9" alt="Canada Moments community feed" width="100%">
      </a>
      <br><sub><b>Canada Moments</b><br>Share the year with the people living it too.</sub>
    </td>
  </tr>
</table>

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
- **Deployment:** Heroku

## Getting started

- **install dependencies:** bundle install
- **set up the database:** rails db:create db:migrate db:seed
- **run the app:** rails server
- The app expects a `.env` file with credentials for Cloudinary and your LLM provider.

## My contributions

- **Community feed:** built the feature end to end: photo uploads (Cloudinary), a shared feed, and commenting and liking on each other's posts
- **Guided reflection content:** wrote and edited the questionnaire questions that structure students' reflection at key points in the journey
- **Demo readiness:** curated the seed data so every feature demos smoothly, and did substantial debugging to get the app live for demo day
- **The rest:** data model, auth and roles, messaging, AI chatbot — was built collaboratively across the team of four.
