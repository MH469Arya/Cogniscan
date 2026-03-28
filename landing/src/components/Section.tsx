"use client";

import { motion } from "framer-motion";
import { ReactNode } from "react";

interface SectionProps {
  children: ReactNode;
  className?: string;
  id?: string;
  delay?: number;
}

export default function Section({ children, className = "", id, delay = 0 }: SectionProps) {
  return (
    <motion.section
      id={id}
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-100px" }}
      transition={{ duration: 0.8, delay }}
      className={`py-16 md:py-24 px-6 md:px-12 max-w-7xl mx-auto ${className}`}
    >
      {children}
    </motion.section>
  );
}
