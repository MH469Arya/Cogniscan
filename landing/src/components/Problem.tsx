"use client";

import Section from "./Section";

const ProblemPoint = ({ text }: { text: string }) => (
  <div className="flex items-start gap-4 p-6 bg-white rounded-2xl border border-soft soft-shadow">
    <div className="w-2 h-2 rounded-full bg-accent mt-2.5 flex-shrink-0" />
    <p className="text-lg text-dark font-medium">{text}</p>
  </div>
);

export default function Problem() {
  return (
    <Section className="bg-soft/20 rounded-[3rem] my-12" id="problem">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        <div>
          <h2 className="text-4xl md:text-5xl font-bold text-dark mb-8">
            The Problem We’re Solving
          </h2>
          <p className="text-xl text-muted mb-12 leading-relaxed">
            Cognitive health is often ignored until it becomes a crisis. Current diagnostic barriers leave millions without a path to early treatment.
          </p>
          <div className="text-2xl font-semibold italic text-primary leading-snug">
            "By the time symptoms are visible, intervention opportunities are limited."
          </div>
        </div>
        
        <div className="grid gap-4">
          <ProblemPoint text="Cognitive decline is often detected too late" />
          <ProblemPoint text="Traditional methods are slow, manual, and inconsistent" />
          <ProblemPoint text="Lack of access in rural / low-resource environments" />
          <ProblemPoint text="Caregivers miss early warning signs" />
        </div>
      </div>
    </Section>
  );
}
