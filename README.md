# event-manager

## Description

This project is designed to manage event attendee communications and data processing. It performs the following key functions:

- **Generates 'Thank You' Emails**: Sends personalized thank you emails to event attendees based on data from a CSV file.
- **Retrieves Legislator Data**: Pulls webhook data from the Google Civic API to get information about legislators based on attendee zip codes.
- **Formats Additional Data**: Extracts and formats additional information from a CSV file, making it easy to access phone numbers, the hour of the day attendees signed up, and the weekday of sign-up.

## Features

- **Email Generation**: Automatically sends thank you emails to attendees.
- **Legislator Information**: Fetches and includes information about local legislators using Google Civic data.
- **Data Formatting**: Organizes additional attendee data for easy future access.

## Setup

1. **Clone the Repository**:

    ```bash
    https://github.com/toby-d-parsons/event-manager.git
    ```

2. **Navigate nto the project directory**:

    ```bash
    cd event-manager
    ```

3. **Configure API Key**:

    ```bash
    ruby event_manager.rb
    ```
