<div align="center">
   <img src="/img/logo.svg?raw=true" width=600 style="background-color:white;">
</div>

# Backend Engineering Take-Home Assignment: Dynamic Pricing Proxy

Welcome to the Tripla backend engineering take-home assignment\! 🧑‍💻 This exercise is designed to simulate a real-world problem you might encounter as part of our team.

⚠️ **Before you begin**, please review the main [FAQ](/TriplaInstructionsReadme.md#frequently-asked-questions). It contains important information, **including our specific guidelines on how to submit your solution.**

## The Challenge

At Tripla, we use a dynamic pricing model for hotel rooms. Instead of static, unchanging rates, our model uses a real-time algorithm to adjust prices based on market demand and other data signals. This helps us maximize both revenue and occupancy.

Our Data and AI team built a powerful model to handle this, but its inference process is computationally expensive to run. To make this product more cost-effective, we analyzed the model's output and found that a calculated room rate remains effective for up to 5 minutes.

This insight presents a great optimization opportunity, and that's where you come in.

## Your Mission

Your mission is to build an efficient service that acts as an intermediary to our dynamic pricing model. This service will be responsible for providing rates to our users while respecting the operational constraints of the expensive model behind it.

You will start with a minimal Ruby on Rails application scaffold that currently returns a static price. You'll need to bring it to life.

## Core Requirements

1.  Integrate the Pricing Model: Modify the provided service to call the external dynamic pricing API to get the latest rates. The model is available as a Docker image: [tripladev/rate-api](https://hub.docker.com/r/tripladev/rate-api).

2.  Ensure Rate Validity: A rate fetched from the pricing model is considered valid for 5 minutes. Your service must ensure that any rate it provides for a given set of parameters (`period`, `hotel`, `room`) is no older than this 5-minute window.

3.  Honor API Usage Limits: The model's API token is limited. Your solution must be able to handle at least 10,000 requests per day from our users while using a single API token for the pricing model.

<details>
  <summary>tripladev/rate-api contents (incase it becomes not-publicly available)</summary>

## 🏨 Tripla Dynamic Pricing Model API

This Docker container runs a simulation of the "computationally expensive" dynamic pricing model mentioned in the take-home assignment. Your proxy service will act as a client to this API to fetch the dynamic room rates.

### How to Run

To start the service, run the following Docker command. The API will be available at [http://localhost:8080](http://localhost:8080):

```bash
docker run -p 8080:8080 tripladev/rate-api
```

---

## API Documentation

The API exposes a single endpoint for fetching room rates in batches.

### Endpoint Details

- **Method:** `POST`
- **Endpoint:** `/pricing`
- **Headers:**
  - `Content-Type: application/json`
  - `token: <your_token>`

### Authentication & Usage Limits

This API has a hard-coded authentication token and a strict rate limit to simulate the constraints of a real-world, costly service.

- **Token:** Only requests with the following token in the `token` header will be accepted:  
  `04aa6f42aa03f220c2ae9a276cd68c62`
- **Rate Limit:** The `/pricing` endpoint is limited to **1,000 requests per day**. During development, you can reset this quota by restarting the Docker container.

---

### Request Format

The API accepts a JSON object containing an `attributes` array. Each object in the array represents a unique room for which you want to retrieve a price.

```json
{
  "attributes": [
    { "period": "Summer", "hotel": "FloatingPointResort", "room": "SingletonRoom" },
    { "period": "Autumn", "hotel": "FloatingPointResort", "room": "SingletonRoom" },
    { "period": "Winter", "hotel": "FloatingPointResort", "room": "SingletonRoom" },
    { "period": "Spring", "hotel": "FloatingPointResort", "room": "SingletonRoom" }
  ]
}
```

---

### Response Format

The API returns a JSON object containing a `rates` array, with each object corresponding to a room in the request, now including its calculated rate.

```json
{
  "rates": [
    { "period": "Summer", "hotel": "FloatingPointResort", "room": "SingletonRoom", "rate": "12000" },
    { "period": "Autumn", "hotel": "FloatingPointResort", "room": "SingletonRoom", "rate": "28000" },
    { "period": "Winter", "hotel": "FloatingPointResort", "room": "SingletonRoom", "rate": "46000" },
    { "period": "Spring", "hotel": "FloatingPointResort", "room": "SingletonRoom", "rate": "73000" }
  ]
}
```

---

### Supported Attribute Values

- **period:** `Summer`, `Autumn`, `Winter`, `Spring`
- **hotel:** `FloatingPointResort`, `GitawayHotel`, `RecursionRetreat`
- **room:** `SingletonRoom`, `BooleanTwin`, `RestfulKing`

---

### Example Request

Here is an example `curl` command to test the running API:

```bash
curl -X POST http://localhost:8080/pricing \
  -H 'token: 04aa6f42aa03f220c2ae9a276cd68c62' \
  -H 'Content-Type: application/json' \
  -d '{
    "attributes": [
      { "period": "Summer", "hotel": "FloatingPointResort", "room": "SingletonRoom" },
      { "period": "Autumn",  "hotel": "GitawayHotel", "room": "RestfulKing" }
    ]
  }'
```

</details>

## How We'll Evaluate Your Work

This isn't just about getting the right answer. We're excited to see how you approach the problem. Treat this as you would a production-ready feature.

  * We'll be looking for clean, well-structured, and testable code. Feel free to add dependencies or refactor the existing scaffold as you see fit.
  * How do you decide on your approach to meeting the performance and cost requirements? Documenting your thought process is a great way to share this.
  * A reliable service anticipates failure. How does your service behave if the pricing model is slow, or returns an error? Providing descriptive error messages to the end-user is a key part of a robust API.
  * We want to see how you work around constraints and navigate an existing codebase to deliver a solution.


## Minimum Deliverables

1.  A link to your Git repository containing the complete solution.
2.  Clear instructions in the `README.md` on how to build, test, and run your service.

We highly value seeing your thought process. A great submission will also include documentation (e.g., in the `README.md`) discussing the design choices you made. Consider outlining different approaches you considered, their potential tradeoffs, and a clear rationale for why you chose your final solution.

Good luck, and we look forward to seeing what you build\!
