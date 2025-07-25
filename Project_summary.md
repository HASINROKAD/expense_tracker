# Flutter Expense Tracker - Project Summary & React.js Migration Guide

## 📱 Project Overview

### Description
A comprehensive Flutter expense tracker application designed for personal finance management. The app provides intuitive expense and income tracking with beautiful charts, dark/light theme support, and comprehensive settings management.

### Main Features
- **Expense & Income Tracking**: Add, edit, and categorize financial transactions
- **Interactive Charts**: Visual representation of spending patterns using Syncfusion charts
- **Dark/Light Theme**: Complete theme switching with adaptive colors
- **Statistics Dashboard**: Detailed analytics with filtering options (All Time, This Year, This Month, This Week)
- **Calendar Integration**: View transactions by date with calendar interface
- **Settings Management**: Profile, notifications, privacy, backup, and preferences
- **Responsive Design**: Optimized for various screen sizes
- **Data Persistence**: Local storage with SharedPreferences and Supabase integration

### Target Users
- Individuals seeking personal finance management
- Users who want visual spending insights
- People preferring mobile-first expense tracking
- Users requiring both online and offline functionality

## 🎨 Theme and Design System

### Color Palette

#### Light Theme
```dart
// Primary Colors
primary: #2C3639 (Dark Teal)
secondary: #0D4242 (Deep Teal)
tertiary: #2E2C2C (Dark Gray)

// Container Colors
containerPrimary: #E5E9E9 (Light Gray)
containerSecondary: #E5E8E8 (Lighter Gray)
containerTertiary: #A27B5C (Brown Accent)

// Text Colors
textPrimary: #333333 (Dark Gray)
textSecondary: #6C757D (Medium Gray)
textWhite: #FFFFFF (White)

// Error Colors
errorPrimary: #BA1A1A (Red)
errorContainer: #FFDAG6 (Light Red)
```

#### Dark Theme
```dart
// Primary Colors
primaryDark: #1A3A3A (Dark Teal)
secondaryDark: #1A5555 (Darker Teal)
tertiaryDark: #4A4A4A (Medium Gray)

// Container Colors
containerPrimaryDark: #2A2A2A (Dark Gray)
containerSecondaryDark: #353535 (Medium Dark Gray)
containerTertiaryDark: #404040 (Lighter Dark Gray)

// Text Colors
textPrimaryDark: #E1E1E1 (Light Gray)
textSecondaryDark: #B0B0B0 (Medium Light Gray)
textTertiaryDark: #888888 (Medium Gray)

// Surface Colors
surfaceDark: #1E1E1E (Very Dark Gray)
backgroundDark: #121212 (Almost Black)
borderDark: #404040 (Border Gray)
```

### Typography
- **Primary Font**: Lato (Google Fonts)
- **Font Weights**: 100, 300, 400, 500, 700, 900
- **Font Sizes**: 12px (helper), 14px (body), 16px (title), 18px (heading)

### Component Styling Guidelines
- **Border Radius**: 12px for cards, 8px for buttons
- **Shadows**: Subtle elevation with 4px blur radius
- **Spacing**: 8px, 16px, 24px grid system
- **Icons**: FontAwesome icons with consistent sizing (16px, 20px, 24px)

## 🏗️ Project Structure

### Flutter Architecture
```
lib/
├── data/                    # Data models and managers
│   ├── chart_data.dart
│   ├── local_data_manager.dart
│   ├── payment_category.dart
│   ├── settings_tile_data.dart
│   ├── supabase_auth.dart
│   └── user_data_model.dart
├── screens/                 # Main application screens
│   ├── add_expense_screen.dart
│   ├── add_income_screen.dart
│   ├── add_screen.dart
│   ├── calendar_screen.dart
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   └── state_screen.dart
├── sub_settings/           # Settings sub-screens
│   ├── about_legal_screen.dart
│   ├── account_screen.dart
│   ├── backup_sync_screen.dart
│   ├── notification_screen.dart
│   ├── preference_screen.dart
│   └── privacy_security_screen.dart
├── theme/                  # Theme configuration
│   ├── custom_theme/
│   ├── theme.dart
│   └── theme_manager.dart
├── utils/                  # Utilities and constants
│   ├── constants/colors.dart
│   └── theme_utils.dart
├── validators/             # Form validation
│   └── custom_validator.dart
├── widgets/                # Reusable components
│   ├── bottom_navigation_bar.dart
│   ├── date_picker.dart
│   ├── dynamic_text_row.dart
│   ├── scrollable_row_card_widget.dart
│   ├── setting_tile_widget.dart
│   ├── state_widgets.dart
│   └── theme_preview_widget.dart
└── main.dart               # Application entry point
```

### Key Dependencies
```yaml
dependencies:
  flutter: sdk
  intl: ^0.20.2                    # Internationalization
  cupertino_icons: ^1.0.8         # iOS-style icons
  font_awesome_flutter: ^10.8.0   # FontAwesome icons
  animated_splash_screen: ^1.3.0  # Splash screen
  curved_navigation_bar: ^1.0.6   # Bottom navigation
  syncfusion_flutter_charts: ^30.1.40    # Charts
  syncfusion_flutter_calendar: ^30.1.40  # Calendar
  google_fonts: ^6.2.1            # Google Fonts
  shared_preferences: ^2.5.3      # Local storage
  supabase_flutter: ^2.9.1        # Backend integration
  flutter_dotenv: ^5.2.1          # Environment variables
  flutter_slidable: ^4.0.0        # Slidable list items
```

## 🚀 React.js Migration Guide

### 1. Project Setup

#### Initialize React.js Project with TypeScript
```bash
# Create new React app with TypeScript
npx create-react-app expense-tracker-react --template typescript

# Navigate to project directory
cd expense-tracker-react

# Install essential dependencies
npm install @types/react @types/react-dom

# Install Tailwind CSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Install additional libraries
npm install react-router-dom @types/react-router-dom
npm install lucide-react react-icons
npm install recharts
npm install date-fns
npm install react-hook-form @hookform/resolvers yup
npm install zustand
npm install react-hot-toast
npm install framer-motion
npm install @headlessui/react
```

#### Configure Tailwind CSS
```javascript
// tailwind.config.js
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Light Theme
        primary: '#2C3639',
        secondary: '#0D4242',
        tertiary: '#2E2C2C',
        'container-primary': '#E5E9E9',
        'container-secondary': '#E5E8E8',
        'container-tertiary': '#A27B5C',
        'text-primary': '#333333',
        'text-secondary': '#6C757D',
        'error-primary': '#BA1A1A',
        
        // Dark Theme
        'primary-dark': '#1A3A3A',
        'secondary-dark': '#1A5555',
        'tertiary-dark': '#4A4A4A',
        'container-primary-dark': '#2A2A2A',
        'container-secondary-dark': '#353535',
        'container-tertiary-dark': '#404040',
        'text-primary-dark': '#E1E1E1',
        'text-secondary-dark': '#B0B0B0',
        'text-tertiary-dark': '#888888',
        'surface-dark': '#1E1E1E',
        'background-dark': '#121212',
        'border-dark': '#404040',
      },
      fontFamily: {
        'lato': ['Lato', 'sans-serif'],
      },
      borderRadius: {
        'card': '12px',
        'button': '8px',
      },
      boxShadow: {
        'card': '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
        'card-dark': '0 4px 6px -1px rgba(0, 0, 0, 0.3)',
      },
    },
  },
  plugins: [],
}
```

### 2. Project Structure for React.js

```
src/
├── components/              # Reusable UI components
│   ├── ui/                 # Basic UI components
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Input.tsx
│   │   ├── Modal.tsx
│   │   └── Select.tsx
│   ├── charts/             # Chart components
│   │   ├── PieChart.tsx
│   │   ├── BarChart.tsx
│   │   └── LineChart.tsx
│   ├── forms/              # Form components
│   │   ├── ExpenseForm.tsx
│   │   ├── IncomeForm.tsx
│   │   └── ProfileForm.tsx
│   ├── layout/             # Layout components
│   │   ├── Header.tsx
│   │   ├── Navigation.tsx
│   │   ├── Sidebar.tsx
│   │   └── Layout.tsx
│   └── widgets/            # Complex widgets
│       ├── ExpenseCard.tsx
│       ├── StatsSummary.tsx
│       └── TransactionList.tsx
├── pages/                  # Page components
│   ├── HomePage.tsx
│   ├── StatsPage.tsx
│   ├── CalendarPage.tsx
│   ├── SettingsPage.tsx
│   └── ProfilePage.tsx
├── hooks/                  # Custom React hooks
│   ├── useLocalStorage.ts
│   ├── useTheme.ts
│   ├── useTransactions.ts
│   └── useAuth.ts
├── store/                  # State management
│   ├── useTransactionStore.ts
│   ├── useThemeStore.ts
│   ├── useUserStore.ts
│   └── index.ts
├── types/                  # TypeScript type definitions
│   ├── transaction.ts
│   ├── user.ts
│   └── index.ts
├── utils/                  # Utility functions
│   ├── constants.ts
│   ├── formatters.ts
│   ├── validators.ts
│   └── api.ts
├── styles/                 # Global styles
│   ├── globals.css
│   └── components.css
└── App.tsx                 # Main application component
```

### 3. Core Type Definitions

```typescript
// types/transaction.ts
export interface Transaction {
  id: string;
  amount: number;
  category: string;
  description: string;
  date: string;
  type: 'income' | 'expense';
  createdAt: string;
  updatedAt: string;
}

export interface TransactionCategory {
  id: string;
  name: string;
  icon: string;
  color: string;
  type: 'income' | 'expense';
}

// types/user.ts
export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  preferences: UserPreferences;
}

export interface UserPreferences {
  theme: 'light' | 'dark' | 'system';
  currency: string;
  language: string;
  notifications: boolean;
}
```

### 4. State Management with Zustand

```typescript
// store/useTransactionStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Transaction, TransactionCategory } from '../types';

interface TransactionStore {
  transactions: Transaction[];
  categories: TransactionCategory[];
  isLoading: boolean;

  // Actions
  addTransaction: (transaction: Omit<Transaction, 'id' | 'createdAt' | 'updatedAt'>) => void;
  updateTransaction: (id: string, updates: Partial<Transaction>) => void;
  deleteTransaction: (id: string) => void;
  getTransactionsByDateRange: (startDate: string, endDate: string) => Transaction[];
  getTransactionsByCategory: (category: string) => Transaction[];
  getTotalIncome: () => number;
  getTotalExpenses: () => number;
  getBalance: () => number;
}

export const useTransactionStore = create<TransactionStore>()(
  persist(
    (set, get) => ({
      transactions: [],
      categories: [
        { id: '1', name: 'Food', icon: 'utensils', color: '#FF6B6B', type: 'expense' },
        { id: '2', name: 'Transport', icon: 'car', color: '#4ECDC4', type: 'expense' },
        { id: '3', name: 'Salary', icon: 'briefcase', color: '#45B7D1', type: 'income' },
        // Add more default categories
      ],
      isLoading: false,

      addTransaction: (transactionData) => {
        const newTransaction: Transaction = {
          ...transactionData,
          id: Date.now().toString(),
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        };
        set((state) => ({
          transactions: [...state.transactions, newTransaction],
        }));
      },

      updateTransaction: (id, updates) => {
        set((state) => ({
          transactions: state.transactions.map((transaction) =>
            transaction.id === id
              ? { ...transaction, ...updates, updatedAt: new Date().toISOString() }
              : transaction
          ),
        }));
      },

      deleteTransaction: (id) => {
        set((state) => ({
          transactions: state.transactions.filter((transaction) => transaction.id !== id),
        }));
      },

      getTransactionsByDateRange: (startDate, endDate) => {
        const { transactions } = get();
        return transactions.filter(
          (transaction) => transaction.date >= startDate && transaction.date <= endDate
        );
      },

      getTransactionsByCategory: (category) => {
        const { transactions } = get();
        return transactions.filter((transaction) => transaction.category === category);
      },

      getTotalIncome: () => {
        const { transactions } = get();
        return transactions
          .filter((transaction) => transaction.type === 'income')
          .reduce((total, transaction) => total + transaction.amount, 0);
      },

      getTotalExpenses: () => {
        const { transactions } = get();
        return transactions
          .filter((transaction) => transaction.type === 'expense')
          .reduce((total, transaction) => total + transaction.amount, 0);
      },

      getBalance: () => {
        const { getTotalIncome, getTotalExpenses } = get();
        return getTotalIncome() - getTotalExpenses();
      },
    }),
    {
      name: 'expense-tracker-storage',
    }
  )
);
```

### 5. Theme Management

```typescript
// store/useThemeStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

type Theme = 'light' | 'dark' | 'system';

interface ThemeStore {
  theme: Theme;
  isDark: boolean;
  setTheme: (theme: Theme) => void;
  toggleTheme: () => void;
}

export const useThemeStore = create<ThemeStore>()(
  persist(
    (set, get) => ({
      theme: 'system',
      isDark: false,

      setTheme: (theme) => {
        set({ theme });

        if (theme === 'system') {
          const systemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
          set({ isDark: systemDark });
          document.documentElement.classList.toggle('dark', systemDark);
        } else {
          const isDark = theme === 'dark';
          set({ isDark });
          document.documentElement.classList.toggle('dark', isDark);
        }
      },

      toggleTheme: () => {
        const { theme } = get();
        const newTheme = theme === 'light' ? 'dark' : 'light';
        get().setTheme(newTheme);
      },
    }),
    {
      name: 'theme-storage',
    }
  )
);

// hooks/useTheme.ts
import { useEffect } from 'react';
import { useThemeStore } from '../store/useThemeStore';

export const useTheme = () => {
  const { theme, isDark, setTheme, toggleTheme } = useThemeStore();

  useEffect(() => {
    // Initialize theme on mount
    setTheme(theme);

    // Listen for system theme changes
    if (theme === 'system') {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      const handleChange = () => setTheme('system');
      mediaQuery.addEventListener('change', handleChange);
      return () => mediaQuery.removeEventListener('change', handleChange);
    }
  }, [theme, setTheme]);

  return { theme, isDark, setTheme, toggleTheme };
};
```

### 6. Core UI Components

```typescript
// components/ui/Card.tsx
import React from 'react';
import { cn } from '../../utils/cn';

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  children: React.ReactNode;
  variant?: 'default' | 'elevated' | 'outlined';
}

export const Card: React.FC<CardProps> = ({
  children,
  className,
  variant = 'default',
  ...props
}) => {
  const variants = {
    default: 'bg-white dark:bg-container-primary-dark border border-gray-200 dark:border-border-dark',
    elevated: 'bg-white dark:bg-container-primary-dark shadow-card dark:shadow-card-dark',
    outlined: 'bg-transparent border-2 border-primary dark:border-primary-dark',
  };

  return (
    <div
      className={cn(
        'rounded-card p-4',
        variants[variant],
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
};

// components/ui/Button.tsx
import React from 'react';
import { cn } from '../../utils/cn';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}) => {
  const variants = {
    primary: 'bg-primary hover:bg-primary/90 text-white dark:bg-primary-dark dark:hover:bg-primary-dark/90',
    secondary: 'bg-secondary hover:bg-secondary/90 text-white dark:bg-secondary-dark dark:hover:bg-secondary-dark/90',
    outline: 'border border-primary text-primary hover:bg-primary hover:text-white dark:border-primary-dark dark:text-primary-dark',
    ghost: 'text-primary hover:bg-primary/10 dark:text-primary-dark dark:hover:bg-primary-dark/10',
  };

  const sizes = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg',
  };

  return (
    <button
      className={cn(
        'rounded-button font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
        variants[variant],
        sizes[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
};
```

### 7. Chart Components with Recharts

```typescript
// components/charts/PieChart.tsx
import React from 'react';
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts';

interface PieChartData {
  name: string;
  value: number;
  color: string;
}

interface CustomPieChartProps {
  data: PieChartData[];
  title?: string;
}

export const CustomPieChart: React.FC<CustomPieChartProps> = ({ data, title }) => {
  return (
    <div className="w-full h-80">
      {title && (
        <h3 className="text-lg font-semibold text-text-primary dark:text-text-primary-dark mb-4">
          {title}
        </h3>
      )}
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={100}
            paddingAngle={5}
            dataKey="value"
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} />
            ))}
          </Pie>
          <Tooltip
            formatter={(value: number) => [`$${value.toFixed(2)}`, 'Amount']}
            contentStyle={{
              backgroundColor: 'var(--tw-colors-white)',
              border: '1px solid var(--tw-colors-gray-200)',
              borderRadius: '8px',
            }}
          />
          <Legend />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
};

// components/charts/BarChart.tsx
import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

interface BarChartData {
  name: string;
  income: number;
  expense: number;
}

interface CustomBarChartProps {
  data: BarChartData[];
  title?: string;
}

export const CustomBarChart: React.FC<CustomBarChartProps> = ({ data, title }) => {
  return (
    <div className="w-full h-80">
      {title && (
        <h3 className="text-lg font-semibold text-text-primary dark:text-text-primary-dark mb-4">
          {title}
        </h3>
      )}
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data} margin={{ top: 20, right: 30, left: 20, bottom: 5 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="name" />
          <YAxis />
          <Tooltip
            formatter={(value: number) => [`$${value.toFixed(2)}`, '']}
            contentStyle={{
              backgroundColor: 'var(--tw-colors-white)',
              border: '1px solid var(--tw-colors-gray-200)',
              borderRadius: '8px',
            }}
          />
          <Bar dataKey="income" fill="#45B7D1" name="Income" />
          <Bar dataKey="expense" fill="#FF6B6B" name="Expense" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
};
```

### 8. Page Implementation Examples

```typescript
// pages/HomePage.tsx
import React, { useState } from 'react';
import { Card } from '../components/ui/Card';
import { Button } from '../components/ui/Button';
import { CustomPieChart } from '../components/charts/PieChart';
import { useTransactionStore } from '../store/useTransactionStore';
import { useTheme } from '../hooks/useTheme';
import { Plus, TrendingUp, TrendingDown, DollarSign } from 'lucide-react';

export const HomePage: React.FC = () => {
  const { transactions, getTotalIncome, getTotalExpenses, getBalance } = useTransactionStore();
  const { isDark } = useTheme();
  const [selectedPeriod, setSelectedPeriod] = useState('This Month');

  const totalIncome = getTotalIncome();
  const totalExpenses = getTotalExpenses();
  const balance = getBalance();

  const chartData = [
    { name: 'Income', value: totalIncome, color: '#45B7D1' },
    { name: 'Expenses', value: totalExpenses, color: '#FF6B6B' },
  ];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-background-dark p-4">
      <div className="max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold text-text-primary dark:text-text-primary-dark">
            Expense Tracker
          </h1>
          <Button variant="primary" className="flex items-center gap-2">
            <Plus size={20} />
            Add Transaction
          </Button>
        </div>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card variant="elevated">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-text-secondary dark:text-text-secondary-dark text-sm">Total Income</p>
                <p className="text-2xl font-bold text-green-600">${totalIncome.toFixed(2)}</p>
              </div>
              <TrendingUp className="text-green-600" size={24} />
            </div>
          </Card>

          <Card variant="elevated">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-text-secondary dark:text-text-secondary-dark text-sm">Total Expenses</p>
                <p className="text-2xl font-bold text-red-600">${totalExpenses.toFixed(2)}</p>
              </div>
              <TrendingDown className="text-red-600" size={24} />
            </div>
          </Card>

          <Card variant="elevated">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-text-secondary dark:text-text-secondary-dark text-sm">Balance</p>
                <p className={`text-2xl font-bold ${balance >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                  ${balance.toFixed(2)}
                </p>
              </div>
              <DollarSign className={balance >= 0 ? 'text-green-600' : 'text-red-600'} size={24} />
            </div>
          </Card>
        </div>

        {/* Charts Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card variant="elevated">
            <CustomPieChart data={chartData} title="Income vs Expenses" />
          </Card>

          <Card variant="elevated">
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-text-primary dark:text-text-primary-dark">
                Recent Transactions
              </h3>
              <div className="space-y-2">
                {transactions.slice(0, 5).map((transaction) => (
                  <div key={transaction.id} className="flex justify-between items-center p-2 rounded border">
                    <div>
                      <p className="font-medium">{transaction.description}</p>
                      <p className="text-sm text-text-secondary dark:text-text-secondary-dark">
                        {transaction.category}
                      </p>
                    </div>
                    <p className={`font-bold ${
                      transaction.type === 'income' ? 'text-green-600' : 'text-red-600'
                    }`}>
                      {transaction.type === 'income' ? '+' : '-'}${transaction.amount.toFixed(2)}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
};
```

### 9. Navigation and Routing

```typescript
// App.tsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Layout } from './components/layout/Layout';
import { HomePage } from './pages/HomePage';
import { StatsPage } from './pages/StatsPage';
import { CalendarPage } from './pages/CalendarPage';
import { SettingsPage } from './pages/SettingsPage';
import { useTheme } from './hooks/useTheme';
import { Toaster } from 'react-hot-toast';

function App() {
  const { isDark } = useTheme();

  return (
    <div className={isDark ? 'dark' : ''}>
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/stats" element={<StatsPage />} />
            <Route path="/calendar" element={<CalendarPage />} />
            <Route path="/settings" element={<SettingsPage />} />
          </Routes>
        </Layout>
        <Toaster
          position="top-right"
          toastOptions={{
            className: isDark ? 'dark:bg-surface-dark dark:text-text-primary-dark' : '',
          }}
        />
      </Router>
    </div>
  );
}

export default App;

// components/layout/Layout.tsx
import React from 'react';
import { Navigation } from './Navigation';
import { Header } from './Header';

interface LayoutProps {
  children: React.ReactNode;
}

export const Layout: React.FC<LayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-background-dark">
      <Header />
      <main className="pb-16 md:pb-0">
        {children}
      </main>
      <Navigation />
    </div>
  );
};
```

## 📋 Development Workflow

### Flutter Development Commands
```bash
# Setup and dependencies
flutter pub get
flutter pub upgrade

# Development
flutter run
flutter run --release

# Build
flutter build apk
flutter build ios
flutter build web

# Testing
flutter test
flutter analyze

# Clean
flutter clean
```

### React.js Development Commands
```bash
# Setup and dependencies
npm install
npm update

# Development
npm start
npm run dev

# Build
npm run build
npm run build:prod

# Testing
npm test
npm run test:coverage

# Linting and formatting
npm run lint
npm run format

# Clean
rm -rf node_modules package-lock.json
npm install
```

### Best Practices

#### Component Organization
- **Single Responsibility**: Each component should have one clear purpose
- **Composition over Inheritance**: Use composition patterns for reusability
- **Props Interface**: Always define TypeScript interfaces for props
- **Default Props**: Provide sensible defaults for optional props

#### State Management
- **Local State**: Use useState for component-specific state
- **Global State**: Use Zustand for app-wide state management
- **Derived State**: Compute derived values in selectors
- **Persistence**: Use persist middleware for data that should survive page refreshes

#### Styling Guidelines
- **Utility-First**: Use Tailwind CSS utility classes
- **Component Variants**: Create reusable component variants
- **Responsive Design**: Mobile-first responsive design approach
- **Dark Mode**: Implement comprehensive dark mode support

#### Performance Optimization
- **Code Splitting**: Implement route-based code splitting
- **Memoization**: Use React.memo and useMemo appropriately
- **Lazy Loading**: Lazy load heavy components and images
- **Bundle Analysis**: Regular bundle size analysis and optimization

### Testing Strategy
- **Unit Tests**: Test individual components and functions
- **Integration Tests**: Test component interactions
- **E2E Tests**: Test complete user workflows
- **Accessibility Tests**: Ensure WCAG compliance

### Deployment Considerations
- **Environment Variables**: Secure API keys and configuration
- **Build Optimization**: Minimize bundle size and optimize assets
- **Progressive Web App**: Implement PWA features for mobile experience
- **Analytics**: Implement user analytics and error tracking

## 🎯 Migration Checklist

### Phase 1: Setup and Foundation
- [ ] Initialize React.js project with TypeScript
- [ ] Configure Tailwind CSS with custom theme
- [ ] Set up project structure and folder organization
- [ ] Implement basic routing with React Router
- [ ] Create core UI components (Button, Card, Input, etc.)

### Phase 2: State Management and Data
- [ ] Implement Zustand stores for transactions and theme
- [ ] Create TypeScript type definitions
- [ ] Set up local storage persistence
- [ ] Implement data validation and error handling

### Phase 3: Core Features
- [ ] Build home page with summary cards
- [ ] Implement transaction forms (add/edit)
- [ ] Create statistics page with charts
- [ ] Build calendar view for transactions
- [ ] Implement settings and preferences

### Phase 4: Polish and Optimization
- [ ] Implement dark/light theme switching
- [ ] Add responsive design for all screen sizes
- [ ] Optimize performance and bundle size
- [ ] Add accessibility features
- [ ] Implement error boundaries and loading states

### Phase 5: Testing and Deployment
- [ ] Write comprehensive tests
- [ ] Set up CI/CD pipeline
- [ ] Deploy to production environment
- [ ] Monitor performance and user feedback

## 🗄️ Database Schema & Supabase Integration

### Database Architecture

The expense tracker uses a comprehensive PostgreSQL database schema hosted on Supabase with the following core tables:

#### **Core Tables:**
- **`tbl_user_data`**: User profile information and preferences
- **`tbl_add_expense_data`**: All expense transactions
- **`tbl_add_income_data`**: All income transactions
- **`tbl_expense_categories`**: Expense category definitions
- **`tbl_income_categories`**: Income category definitions
- **`tbl_budgets`**: Budget tracking and management

#### **Key Features:**
- **Row Level Security (RLS)**: User data isolation and security
- **Automatic Timestamps**: Created/updated timestamps with triggers
- **Data Validation**: Comprehensive constraints and checks
- **Performance Optimization**: Strategic indexes for fast queries
- **Real-time Capabilities**: Supabase real-time subscriptions
- **Default Categories**: Pre-populated expense and income categories

### Database Schema Implementation

```sql
-- Complete schema available in supabase_schema.sql
-- Key table structures:

CREATE TABLE public.tbl_user_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  first_name TEXT,
  last_name TEXT,
  user_name VARCHAR(50) UNIQUE,
  phone_number VARCHAR(20),
  email TEXT,
  avatar_url TEXT,
  currency_preference VARCHAR(3) DEFAULT 'USD',
  theme_preference VARCHAR(10) DEFAULT 'system',
  user_uuid UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE TABLE public.tbl_add_expense_data (
  id BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  expense_amount DECIMAL(12,2) NOT NULL CHECK (expense_amount > 0),
  description TEXT NOT NULL,
  expense_category TEXT NOT NULL,
  expense_payment_method TEXT NOT NULL,
  expense_payment_status TEXT DEFAULT 'completed',
  expense_date DATE DEFAULT CURRENT_DATE,
  receipt_url TEXT,
  notes TEXT,
  location TEXT,
  tags TEXT[],
  is_recurring BOOLEAN DEFAULT false,
  recurring_frequency TEXT,
  user_uuid UUID REFERENCES auth.users(id) ON DELETE CASCADE
);
```

### React.js Database Integration

#### **1. Supabase Client Setup**

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';
import { Database } from './database.types';

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL!;
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  },
  realtime: {
    params: {
      eventsPerSecond: 10
    }
  }
});

// Environment variables (.env)
REACT_APP_SUPABASE_URL=your_supabase_url
REACT_APP_SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### **2. TypeScript Database Types**

```typescript
// types/database.ts
export interface Database {
  public: {
    Tables: {
      tbl_user_data: {
        Row: UserData;
        Insert: Omit<UserData, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<UserData, 'id' | 'created_at' | 'updated_at'>>;
      };
      tbl_add_expense_data: {
        Row: ExpenseData;
        Insert: Omit<ExpenseData, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<ExpenseData, 'id' | 'created_at' | 'updated_at'>>;
      };
      tbl_add_income_data: {
        Row: IncomeData;
        Insert: Omit<IncomeData, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<IncomeData, 'id' | 'created_at' | 'updated_at'>>;
      };
    };
  };
}

export interface UserData {
  id: string;
  created_at: string;
  updated_at: string;
  first_name: string | null;
  last_name: string | null;
  user_name: string | null;
  phone_number: string | null;
  email: string | null;
  avatar_url: string | null;
  currency_preference: string;
  theme_preference: 'light' | 'dark' | 'system';
  language_preference: string;
  notification_enabled: boolean;
  backup_enabled: boolean;
  user_uuid: string;
}

export interface ExpenseData {
  id: number;
  created_at: string;
  updated_at: string;
  expense_amount: number;
  description: string;
  expense_category: string;
  expense_payment_method: PaymentMethod;
  expense_payment_status: PaymentStatus;
  expense_date: string;
  receipt_url: string | null;
  notes: string | null;
  location: string | null;
  tags: string[] | null;
  is_recurring: boolean;
  recurring_frequency: RecurringFrequency | null;
  user_uuid: string;
}

export interface IncomeData {
  id: number;
  created_at: string;
  updated_at: string;
  income_amount: number;
  description: string;
  income_category: string;
  income_payment_method: PaymentMethod;
  income_payment_status: PaymentStatus;
  income_date: string;
  receipt_url: string | null;
  notes: string | null;
  location: string | null;
  tags: string[] | null;
  is_recurring: boolean;
  recurring_frequency: RecurringFrequency | null;
  user_uuid: string;
}

export type PaymentMethod = 'cash' | 'credit_card' | 'debit_card' | 'bank_transfer' | 'digital_wallet' | 'check' | 'other';
export type PaymentStatus = 'completed' | 'pending' | 'failed' | 'cancelled' | 'received';
export type RecurringFrequency = 'daily' | 'weekly' | 'monthly' | 'yearly';
```

#### **3. Database Service Layer**

```typescript
// services/database.service.ts
import { supabase } from '../lib/supabase';
import { Database, ExpenseData, IncomeData, UserData } from '../types/database';

export class DatabaseService {
  // User operations
  static async getUserProfile(userId: string): Promise<UserData | null> {
    try {
      const { data, error } = await supabase
        .from('tbl_user_data')
        .select('*')
        .eq('user_uuid', userId)
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      console.error('Error fetching user profile:', error);
      return null;
    }
  }

  static async updateUserProfile(userId: string, updates: Partial<UserData>): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('tbl_user_data')
        .update(updates)
        .eq('user_uuid', userId);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error updating user profile:', error);
      return false;
    }
  }

  // Expense operations
  static async getExpenses(userId: string, filters?: {
    startDate?: string;
    endDate?: string;
    category?: string;
    limit?: number;
  }): Promise<ExpenseData[]> {
    try {
      let query = supabase
        .from('tbl_add_expense_data')
        .select('*')
        .eq('user_uuid', userId)
        .order('expense_date', { ascending: false });

      if (filters?.startDate) {
        query = query.gte('expense_date', filters.startDate);
      }
      if (filters?.endDate) {
        query = query.lte('expense_date', filters.endDate);
      }
      if (filters?.category) {
        query = query.eq('expense_category', filters.category);
      }
      if (filters?.limit) {
        query = query.limit(filters.limit);
      }

      const { data, error } = await query;
      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching expenses:', error);
      return [];
    }
  }

  static async addExpense(expense: Database['public']['Tables']['tbl_add_expense_data']['Insert']): Promise<ExpenseData | null> {
    try {
      const { data, error } = await supabase
        .from('tbl_add_expense_data')
        .insert(expense)
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      console.error('Error adding expense:', error);
      return null;
    }
  }

  static async updateExpense(id: number, updates: Database['public']['Tables']['tbl_add_expense_data']['Update']): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('tbl_add_expense_data')
        .update(updates)
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error updating expense:', error);
      return false;
    }
  }

  static async deleteExpense(id: number): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('tbl_add_expense_data')
        .delete()
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error deleting expense:', error);
      return false;
    }
  }

  // Income operations (similar pattern)
  static async getIncome(userId: string, filters?: {
    startDate?: string;
    endDate?: string;
    category?: string;
    limit?: number;
  }): Promise<IncomeData[]> {
    try {
      let query = supabase
        .from('tbl_add_income_data')
        .select('*')
        .eq('user_uuid', userId)
        .order('income_date', { ascending: false });

      if (filters?.startDate) {
        query = query.gte('income_date', filters.startDate);
      }
      if (filters?.endDate) {
        query = query.lte('income_date', filters.endDate);
      }
      if (filters?.category) {
        query = query.eq('income_category', filters.category);
      }
      if (filters?.limit) {
        query = query.limit(filters.limit);
      }

      const { data, error } = await query;
      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching income:', error);
      return [];
    }
  }

  // Analytics operations
  static async getMonthlySpendingByCategory(userId: string, year: number, month: number) {
    try {
      const { data, error } = await supabase
        .rpc('get_monthly_spending_by_category', {
          p_user_uuid: userId,
          p_year: year,
          p_month: month
        });

      if (error) throw error;
      return data || [];
    } catch (error) {
      console.error('Error fetching monthly spending:', error);
      return [];
    }
  }

  static async getUserBalanceSummary(userId: string) {
    try {
      const { data, error } = await supabase
        .from('v_user_balance_summary')
        .select('*')
        .eq('user_uuid', userId)
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      console.error('Error fetching balance summary:', error);
      return null;
    }
  }
}
```

#### **4. React Query Hooks for Data Fetching**

```typescript
// hooks/useExpenses.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { DatabaseService } from '../services/database.service';
import { ExpenseData } from '../types/database';
import { useAuth } from './useAuth';
import toast from 'react-hot-toast';

export const useExpenses = (filters?: {
  startDate?: string;
  endDate?: string;
  category?: string;
  limit?: number;
}) => {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['expenses', user?.id, filters],
    queryFn: () => DatabaseService.getExpenses(user!.id, filters),
    enabled: !!user?.id,
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  });
};

export const useAddExpense = () => {
  const queryClient = useQueryClient();
  const { user } = useAuth();

  return useMutation({
    mutationFn: (expense: Omit<ExpenseData, 'id' | 'created_at' | 'updated_at'>) =>
      DatabaseService.addExpense(expense),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] });
      queryClient.invalidateQueries({ queryKey: ['balance-summary'] });
      toast.success('Expense added successfully!');
    },
    onError: (error) => {
      console.error('Error adding expense:', error);
      toast.error('Failed to add expense. Please try again.');
    },
  });
};

export const useUpdateExpense = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, updates }: { id: number; updates: Partial<ExpenseData> }) =>
      DatabaseService.updateExpense(id, updates),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] });
      queryClient.invalidateQueries({ queryKey: ['balance-summary'] });
      toast.success('Expense updated successfully!');
    },
    onError: (error) => {
      console.error('Error updating expense:', error);
      toast.error('Failed to update expense. Please try again.');
    },
  });
};

export const useDeleteExpense = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => DatabaseService.deleteExpense(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] });
      queryClient.invalidateQueries({ queryKey: ['balance-summary'] });
      toast.success('Expense deleted successfully!');
    },
    onError: (error) => {
      console.error('Error deleting expense:', error);
      toast.error('Failed to delete expense. Please try again.');
    },
  });
};

// hooks/useIncome.ts (similar pattern for income operations)
export const useIncome = (filters?: {
  startDate?: string;
  endDate?: string;
  category?: string;
  limit?: number;
}) => {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['income', user?.id, filters],
    queryFn: () => DatabaseService.getIncome(user!.id, filters),
    enabled: !!user?.id,
    staleTime: 5 * 60 * 1000,
    cacheTime: 10 * 60 * 1000,
  });
};

// hooks/useAnalytics.ts
export const useMonthlySpending = (year: number, month: number) => {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['monthly-spending', user?.id, year, month],
    queryFn: () => DatabaseService.getMonthlySpendingByCategory(user!.id, year, month),
    enabled: !!user?.id,
    staleTime: 10 * 60 * 1000, // 10 minutes for analytics
  });
};

export const useBalanceSummary = () => {
  const { user } = useAuth();

  return useQuery({
    queryKey: ['balance-summary', user?.id],
    queryFn: () => DatabaseService.getUserBalanceSummary(user!.id),
    enabled: !!user?.id,
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};
```

#### **5. Real-time Subscriptions**

```typescript
// hooks/useRealtimeSubscriptions.ts
import { useEffect } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { supabase } from '../lib/supabase';
import { useAuth } from './useAuth';

export const useRealtimeSubscriptions = () => {
  const queryClient = useQueryClient();
  const { user } = useAuth();

  useEffect(() => {
    if (!user?.id) return;

    // Subscribe to expense changes
    const expenseSubscription = supabase
      .channel('expense-changes')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'tbl_add_expense_data',
          filter: `user_uuid=eq.${user.id}`,
        },
        (payload) => {
          console.log('Expense change received:', payload);

          // Invalidate relevant queries
          queryClient.invalidateQueries({ queryKey: ['expenses'] });
          queryClient.invalidateQueries({ queryKey: ['balance-summary'] });
          queryClient.invalidateQueries({ queryKey: ['monthly-spending'] });
        }
      )
      .subscribe();

    // Subscribe to income changes
    const incomeSubscription = supabase
      .channel('income-changes')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'tbl_add_income_data',
          filter: `user_uuid=eq.${user.id}`,
        },
        (payload) => {
          console.log('Income change received:', payload);

          // Invalidate relevant queries
          queryClient.invalidateQueries({ queryKey: ['income'] });
          queryClient.invalidateQueries({ queryKey: ['balance-summary'] });
        }
      )
      .subscribe();

    // Subscribe to user profile changes
    const profileSubscription = supabase
      .channel('profile-changes')
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'tbl_user_data',
          filter: `user_uuid=eq.${user.id}`,
        },
        (payload) => {
          console.log('Profile change received:', payload);
          queryClient.invalidateQueries({ queryKey: ['user-profile'] });
        }
      )
      .subscribe();

    // Cleanup subscriptions
    return () => {
      expenseSubscription.unsubscribe();
      incomeSubscription.unsubscribe();
      profileSubscription.unsubscribe();
    };
  }, [user?.id, queryClient]);
};

// Usage in App.tsx
import { useRealtimeSubscriptions } from './hooks/useRealtimeSubscriptions';

function App() {
  useRealtimeSubscriptions(); // Enable real-time updates

  // ... rest of app
}
```

#### **6. Authentication Integration**

```typescript
// hooks/useAuth.ts
import { useEffect, useState } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '../lib/supabase';

export const useAuth = () => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      setLoading(false);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        setSession(session);
        setUser(session?.user ?? null);
        setLoading(false);
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    return { data, error };
  };

  const signUp = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
    });
    return { data, error };
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    return { error };
  };

  const resetPassword = async (email: string) => {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email);
    return { data, error };
  };

  return {
    user,
    session,
    loading,
    signIn,
    signUp,
    signOut,
    resetPassword,
  };
};
```

#### **7. Error Handling and Validation**

```typescript
// utils/validation.ts
import * as yup from 'yup';

export const expenseSchema = yup.object({
  expense_amount: yup
    .number()
    .required('Amount is required')
    .positive('Amount must be positive')
    .max(999999.99, 'Amount too large'),
  description: yup
    .string()
    .required('Description is required')
    .min(3, 'Description must be at least 3 characters')
    .max(255, 'Description too long'),
  expense_category: yup
    .string()
    .required('Category is required'),
  expense_payment_method: yup
    .string()
    .required('Payment method is required')
    .oneOf(['cash', 'credit_card', 'debit_card', 'bank_transfer', 'digital_wallet', 'check', 'other']),
  expense_date: yup
    .date()
    .required('Date is required')
    .max(new Date(), 'Date cannot be in the future'),
  notes: yup
    .string()
    .max(500, 'Notes too long'),
});

export const incomeSchema = yup.object({
  income_amount: yup
    .number()
    .required('Amount is required')
    .positive('Amount must be positive')
    .max(999999.99, 'Amount too large'),
  description: yup
    .string()
    .required('Description is required')
    .min(3, 'Description must be at least 3 characters')
    .max(255, 'Description too long'),
  income_category: yup
    .string()
    .required('Category is required'),
  income_payment_method: yup
    .string()
    .required('Payment method is required')
    .oneOf(['cash', 'credit_card', 'debit_card', 'bank_transfer', 'digital_wallet', 'check', 'other']),
  income_date: yup
    .date()
    .required('Date is required')
    .max(new Date(), 'Date cannot be in the future'),
  notes: yup
    .string()
    .max(500, 'Notes too long'),
});

// utils/errorHandler.ts
import { PostgrestError } from '@supabase/supabase-js';
import toast from 'react-hot-toast';

export const handleDatabaseError = (error: PostgrestError | Error) => {
  console.error('Database error:', error);

  if ('code' in error) {
    // PostgrestError
    switch (error.code) {
      case '23505': // Unique violation
        toast.error('This record already exists');
        break;
      case '23503': // Foreign key violation
        toast.error('Invalid reference data');
        break;
      case '23514': // Check constraint violation
        toast.error('Invalid data provided');
        break;
      case 'PGRST116': // Row level security violation
        toast.error('Access denied');
        break;
      default:
        toast.error('Database operation failed');
    }
  } else {
    toast.error('An unexpected error occurred');
  }
};
```

#### **8. Offline-First Data Synchronization**

```typescript
// hooks/useOfflineSync.ts
import { useEffect, useState } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { DatabaseService } from '../services/database.service';

interface PendingOperation {
  id: string;
  type: 'CREATE' | 'UPDATE' | 'DELETE';
  table: 'expenses' | 'income';
  data: any;
  timestamp: number;
}

export const useOfflineSync = () => {
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [pendingOperations, setPendingOperations] = useState<PendingOperation[]>([]);
  const queryClient = useQueryClient();

  useEffect(() => {
    const handleOnline = () => setIsOnline(true);
    const handleOffline = () => setIsOnline(false);

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  useEffect(() => {
    if (isOnline && pendingOperations.length > 0) {
      syncPendingOperations();
    }
  }, [isOnline, pendingOperations]);

  const addPendingOperation = (operation: Omit<PendingOperation, 'id' | 'timestamp'>) => {
    const newOperation: PendingOperation = {
      ...operation,
      id: Date.now().toString(),
      timestamp: Date.now(),
    };

    setPendingOperations(prev => [...prev, newOperation]);

    // Store in localStorage for persistence
    const stored = localStorage.getItem('pendingOperations');
    const existing = stored ? JSON.parse(stored) : [];
    localStorage.setItem('pendingOperations', JSON.stringify([...existing, newOperation]));
  };

  const syncPendingOperations = async () => {
    for (const operation of pendingOperations) {
      try {
        switch (operation.type) {
          case 'CREATE':
            if (operation.table === 'expenses') {
              await DatabaseService.addExpense(operation.data);
            } else if (operation.table === 'income') {
              await DatabaseService.addIncome(operation.data);
            }
            break;
          case 'UPDATE':
            if (operation.table === 'expenses') {
              await DatabaseService.updateExpense(operation.data.id, operation.data);
            } else if (operation.table === 'income') {
              await DatabaseService.updateIncome(operation.data.id, operation.data);
            }
            break;
          case 'DELETE':
            if (operation.table === 'expenses') {
              await DatabaseService.deleteExpense(operation.data.id);
            } else if (operation.table === 'income') {
              await DatabaseService.deleteIncome(operation.data.id);
            }
            break;
        }

        // Remove successful operation
        setPendingOperations(prev => prev.filter(op => op.id !== operation.id));
      } catch (error) {
        console.error('Failed to sync operation:', operation, error);
        // Keep failed operations for retry
      }
    }

    // Update localStorage
    localStorage.setItem('pendingOperations', JSON.stringify(pendingOperations));

    // Invalidate queries after sync
    queryClient.invalidateQueries();
  };

  return {
    isOnline,
    pendingOperations: pendingOperations.length,
    addPendingOperation,
  };
};
```

This comprehensive guide provides everything needed to recreate the Flutter expense tracker as a modern React.js application with TypeScript and Tailwind CSS, maintaining the same functionality and design principles while leveraging web-specific optimizations and best practices.
