"use client";

import { motion } from "framer-motion";
import { Mic, User, Activity, BarChart3 } from "lucide-react";
import Section from "./Section";

const Card = ({ icon: Icon, title, description, index }: any) => (
  <motion.div
    initial={{ opacity: 0, scale: 0.9 }}
    whileInView={{ opacity: 1, scale: 1 }}
    viewport={{ once: true }}
    transition={{ delay: index * 0.1 }}
    whileHover={{ y: -10 }}
    className="bg-white p-8 rounded-3xl soft-shadow border border-soft group cursor-pointer"
  >
    <div className="w-14 h-14 bg-soft rounded-2xl flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-colors mb-6">
      <Icon size={28} />
    </div>
    <h4 className="text-xl font-bold text-dark mb-4">{title}</h4>
    <p className="text-muted leading-relaxed">{description}</p>
  </motion.div>
);

export default function HowItWorks() {
  const items = [
    {
      icon: Mic,
      title: "Speech Pattern Analysis",
      description: "Detects hesitation, tone variation, and key memory gaps during natural conversation."
    },
    {
      icon: User,
      title: "Facial Expression Recognition",
      description: "Identifies emotional inconsistencies and micro-signals of cognitive stress."
    },
    {
      icon: Activity,
      title: "Cognitive Task Monitoring",
      description: "Tracks real-time reaction speed, accuracy, and memory retention performance."
    },
    {
      icon: BarChart3,
      title: "AI Risk Scoring",
      description: "Aggregates all behavioral signals into an actionable, real-time risk indicator."
    }
  ];

  return (
    <Section id="how-it-works">
      <h2 className="text-4xl md:text-5xl font-bold text-dark mb-16 text-center">How It Works</h2>
      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {items.map((item, i) => (
          <Card key={i} {...item} index={i} />
        ))}
      </div>
    </Section>
  );
}
