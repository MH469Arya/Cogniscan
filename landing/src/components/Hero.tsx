"use client";

import { motion } from "framer-motion";
import { Brain, ArrowRight, ShieldCheck, WifiOff } from "lucide-react";
import Section from "./Section";
import Link from "next/link";

export default function Hero() {
  return (
    <Section className="flex flex-col items-center text-center pt-32 pb-20">
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="mb-6 px-4 py-1 rounded-full bg-soft text-primary font-semibold text-sm tracking-wide uppercase"
      >
        Healthcare + AI
      </motion.div>
      
      <h1 className="text-5xl md:text-7xl font-bold tracking-tight mb-6 text-dark max-w-4xl">
        Detect Cognitive Decline <span className="text-primary italic">Before It’s Too Late</span>
      </h1>
      
      <p className="text-xl md:text-2xl text-muted max-w-2xl mb-10 leading-relaxed font-normal">
        Cogniscan uses AI to analyze speech, facial expressions, and cognitive behavior—enabling early detection and timely intervention.
      </p>
      
      <p className="text-lg text-secondary mb-12 font-medium bg-soft/30 px-6 py-2 rounded-lg">
        Designed for real-world use, even in low-resource environments.
      </p>
      
      <div className="flex flex-col sm:flex-row gap-4 mb-20 w-full justify-center">
        <button className="bg-accent hover:bg-accent/90 text-white px-8 py-4 rounded-xl font-bold text-lg soft-shadow transition-all hover:scale-105 flex items-center justify-center gap-2">
          Get Started <ArrowRight size={20} />
        </button>
        <Link href="/login" className="bg-white border-2 border-primary text-primary hover:bg-soft px-8 py-4 rounded-xl font-bold text-lg transition-all flex items-center justify-center">
          Login
        </Link>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8 w-full max-w-4xl border-t border-soft pt-12">
        <div className="flex items-center gap-3 justify-center md:justify-start">
          <div className="p-2 bg-soft rounded-lg text-primary"><Brain size={24} /></div>
          <span className="font-semibold text-dark">AI-Powered</span>
        </div>
        <div className="flex items-center gap-3 justify-center md:justify-start">
          <div className="p-2 bg-soft rounded-lg text-primary"><ShieldCheck size={24} /></div>
          <span className="font-semibold text-dark">Privacy-First</span>
        </div>
        <div className="flex items-center gap-3 justify-center md:justify-start">
          <div className="p-2 bg-soft rounded-lg text-primary"><WifiOff size={24} /></div>
          <span className="font-semibold text-dark">Low-Bandwidth Ready</span>
        </div>
      </div>
    </Section>
  );
}
