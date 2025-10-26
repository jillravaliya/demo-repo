# Daily Activity Tracker

[![Next.js](https://img.shields.io/badge/Next.js-15.5-black?logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue?logo=typescript)](https://www.typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Database-green?logo=supabase)](https://supabase.com/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.x-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)

A full-stack web application for tracking daily activities with authentication, analytics, and beautiful charts.

---

## What This App Does

Track your daily activities and get insights:

- **📝 Log Activities** - Record what you did (work, study, exercise, etc.)
- **📊 Analytics** - See charts and patterns in your activities
- **🔐 Secure** - User authentication with Supabase
- **📱 Responsive** - Works on all devices

**Perfect for:** Students, freelancers, fitness enthusiasts, productivity tracking

---

## Features

- ✅ User authentication (login/signup)
- ✅ Log activities with categories and duration
- ✅ View all activities in a table
- ✅ Edit and delete activities
- ✅ Beautiful analytics with pie charts and bar charts
- ✅ Weekly activity trends
- ✅ Most frequent activity tracking

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Next.js 15, React, TypeScript |
| **Styling** | Tailwind CSS |
| **Database** | Supabase (PostgreSQL) |
| **Auth** | Supabase Auth |
| **Charts** | Chart.js |

---

## Quick Start

### 1. Clone and Install

```bash
git clone https://github.com/your-username/daily-activity-tracker.git
cd daily-activity-tracker
npm install
```

### 2. Set Up Supabase

1. **Create a Supabase account** at https://supabase.com
2. **Create a new project**
3. **Get your credentials** from Settings → API:
   - Project URL
   - anon public key

### 3. Create Environment File

Create `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
```

### 4. Set Up Database

1. Go to Supabase SQL Editor
2. Copy contents of `database-setup.sql`
3. Paste and click "Run"

### 5. Run the App

```bash
npm run dev
```

Visit: **http://localhost:3000**

---

## Email Verification Issue?

If signup asks for email verification:

1. Go to Supabase Dashboard
2. Authentication → Settings
3. Turn OFF "Enable email confirmations"
4. Save and try again!

---

## Project Structure

```
daily-activity-tracker/
├── src/
│   ├── app/              # Pages (Next.js App Router)
│   │   ├── page.tsx     # Homepage
│   │   ├── auth/        # Login/Signup
│   │   ├── activities/  # Activity management
│   │   └── analysis/    # Charts & analytics
│   ├── components/       # Reusable UI components
│   ├── context/          # Global state (auth)
│   └── lib/              # Database connection
├── database-setup.sql   # SQL to run in Supabase
├── .env.local           # Your credentials
└── package.json         # Dependencies
```

---

## Available Scripts

```bash
npm run dev      # Start development server
npm run build    # Build for production
npm start        # Start production server
npm run lint     # Run ESLint
```

---

## Database Schema

The app uses one main table:

```sql
CREATE TABLE activities (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  duration INTEGER NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

See `database-setup.sql` for full schema with RLS policies.

---

## Deployment

### Option 1: Vercel (Recommended)

1. Push to GitHub
2. Go to https://vercel.com
3. Import your repository
4. Add environment variables
5. Deploy!

### Option 2: Railway

1. Push to GitHub
2. Go to https://railway.app
3. New Project → Deploy from GitHub
4. Add environment variables
5. Deploy!

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

MIT License

---

## Support

- **Issues**: [GitHub Issues](https://github.com/your-username/daily-activity-tracker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/daily-activity-tracker/discussions)

---

**Made with ❤️ for tracking your daily life**
