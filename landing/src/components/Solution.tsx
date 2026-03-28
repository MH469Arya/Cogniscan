"use client";

import Section from "./Section";

export default function Solution() {
  return (
    <Section className="text-center py-32" id="solution">
      <h2 className="text-4xl md:text-5xl font-bold text-dark mb-8">
        Meet Cogniscan
      </h2>
      <p className="text-2xl text-muted max-w-3xl mx-auto mb-16 leading-relaxed">
        A multimodal AI system that continuously evaluates cognitive health using behavioral and visual signals.
      </p>
      
      <div className="grid md:grid-cols-3 gap-12">
        <div className="p-8 bg-white rounded-3xl border border-soft transition-all hover:scale-105">
          <h3 className="text-6xl font-black text-primary/10 mb-4 tracking-tighter">01</h3>
          <h4 className="text-2xl font-bold text-dark mb-4">Early Detection</h4>
          <p className="text-muted">Spots subtle patterns long before visible symptoms emerge.</p>
        </div>
        <div className="p-8 bg-white rounded-3xl border border-soft transition-all hover:scale-105 shadow-xl shadow-primary/5">
          <h3 className="text-6xl font-black text-primary/10 mb-4 tracking-tighter">02</h3>
          <h4 className="text-2xl font-bold text-dark mb-4">Continuous Monitoring</h4>
          <p className="text-muted">Provides a dynamic view of cognitive health over time.</p>
        </div>
        <div className="p-8 bg-white rounded-3xl border border-soft transition-all hover:scale-105">
          <h3 className="text-6xl font-black text-primary/10 mb-4 tracking-tighter">03</h3>
          <h4 className="text-2xl font-bold text-dark mb-4">Accessible Anywhere</h4>
          <p className="text-muted">Works on basic devices with minimal internet connectivity.</p>
        </div>
      </div>
    </Section>
  );
}
