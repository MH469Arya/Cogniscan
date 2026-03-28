"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Brain, Lock, Mail, Loader2 } from "lucide-react";
import Link from "next/link";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError("");

    // Simulate network delay
    await new Promise((resolve) => setTimeout(resolve, 1000));

    if (email === "sarth@gmail.com" && password === "sarth123") {
      // Mock success - in a real app would set cookies/tokens
      // For now, redirect to a mock dashboard or back home
      router.push("/?login=success");
    } else {
      setError("Invalid email or password. Please try again.");
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex flex-col items-center justify-center p-6">
      <Link href="/" className="mb-12 flex items-center gap-2 text-primary hover:opacity-80 transition-opacity">
        <Brain size={32} />
        <span className="text-2xl font-bold text-dark tracking-tight">Cogniscan</span>
      </Link>

      <div className="w-full max-w-md bg-white p-10 rounded-[2.5rem] soft-shadow border border-soft">
        <h1 className="text-3xl font-bold text-dark mb-2 text-center">Welcome Back</h1>
        <p className="text-muted text-center mb-10 font-medium">Early Insights for a Sharper Mind</p>

        <form onSubmit={handleLogin} className="space-y-6">
          <div className="space-y-2">
            <label className="text-sm font-bold text-dark ml-2 uppercase tracking-wider">Email Address</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-muted" size={20} />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="sarth@gmail.com"
                className="w-full pl-12 pr-6 py-4 bg-soft/30 border border-soft rounded-2xl focus:outline-none focus:border-primary transition-all text-dark font-medium"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-bold text-dark ml-2 uppercase tracking-wider">Password</label>
            <div className="relative">
              <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-muted" size={20} />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full pl-12 pr-6 py-4 bg-soft/30 border border-soft rounded-2xl focus:outline-none focus:border-primary transition-all text-dark font-medium"
              />
            </div>
          </div>

          {error && (
            <div className="p-4 bg-red-50 text-red-500 rounded-xl text-sm font-medium border border-red-100 italic">
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-primary hover:bg-primary/90 text-white py-4 rounded-2xl font-bold text-lg transition-all hover:scale-[1.02] flex items-center justify-center gap-2"
          >
            {isLoading ? <Loader2 className="animate-spin" size={20} /> : "Login"}
          </button>
        </form>

        <div className="mt-10 text-center text-muted text-sm font-medium">
          Don't have an account? <Link href="#" className="text-primary hover:underline">Sign Up</Link>
        </div>
      </div>
      
      <p className="mt-8 text-xs text-muted/50 font-medium">
        Mock Credentials: sarth@gmail.com / sarth123
      </p>
    </div>
  );
}
