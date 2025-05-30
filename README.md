# Whispr

Whispr is a modern, anonymous confession platform built with Ruby on Rails. It allows users to share their thoughts and confessions anonymously in a safe and engaging environment.
![image](https://github.com/user-attachments/assets/10b43969-6556-4ae1-84a2-64c217b2231b)


## Features

- Anonymous confession posting
- Real-time form validation
- Modern UI with Tailwind CSS
- Responsive design
- Rate limiting for spam prevention
- SweetAlert2 for beautiful notifications
- Turbo for smooth, SPA-like experience

## Tech Stack

- Ruby on Rails 7
- Ruby 3.2.2
- PostgreSQL
- Tailwind CSS
- Stimulus.js
- Turbo
- SweetAlert2

## Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL
- Node.js and Yarn
- Redis (for rate limiting)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/arshtandon121/whispr.git
   cd whispr
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start the Redis server (required for rate limiting)

5. Start the Rails server:
   ```bash
   rails server
   ```

6. Visit `http://localhost:3000` in your browser

## Development

- Run tests: `rails test`
- Run linters: `rubocop`
- Run JavaScript tests: `yarn test`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [SweetAlert2](https://sweetalert2.github.io/)
- [Stimulus](https://stimulus.hotwired.dev/)
- [Turbo](https://turbo.hotwired.dev/)
