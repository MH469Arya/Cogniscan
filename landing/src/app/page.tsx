import Hero from "@/components/Hero";
import Problem from "@/components/Problem";
import Solution from "@/components/Solution";
import HowItWorks from "@/components/HowItWorks";
import Features from "@/components/Features";
import Impact from "@/components/Impact";
import Caregiver from "@/components/Caregiver";
import UseCases from "@/components/UseCases";
import CTA from "@/components/CTA";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <main className="min-h-screen bg-background">
      {/* Navigation could go here, but focusing on sections as requested */}
      <Hero />
      <Problem />
      <Solution />
      <HowItWorks />
      <Features />
      <Impact />
      <Caregiver />
      <UseCases />
      <CTA />
      <Footer />
    </main>
  );
}
