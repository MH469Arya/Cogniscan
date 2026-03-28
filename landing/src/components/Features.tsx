import Section from "./Section";
import { Check } from "lucide-react";

const FeatureItem = ({ title, description }: any) => (
  <div className="flex gap-4 group">
    <div className="flex-shrink-0 w-8 h-8 rounded-full bg-soft flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-all">
      <Check size={18} />
    </div>
    <div>
      <h4 className="text-xl font-bold text-dark mb-2">{title}</h4>
      <p className="text-muted leading-relaxed">{description}</p>
    </div>
  </div>
);

export default function Features() {
  return (
    <Section className="bg-dark rounded-[3rem] my-24 p-12 md:p-24" id="features">
      <div className="text-center mb-16">
        <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">Built for Real-World Impact</h2>
        <p className="text-xl text-soft/70 max-w-2xl mx-auto">Scalable technology designed to bridge the gap in neuro-healthcare.</p>
      </div>
      
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-12">
        <FeatureItem 
          title="Low-Resource Optimization" 
          description="Lightweight processing that works seamlessly on any hardware, even with limited bandwidth."
        />
        <FeatureItem 
          title="Real-Time Caregiver Alerts" 
          description="Instant notification system keeps family members and medical staff informed when risks jump."
        />
        <FeatureItem 
          title="Personalized Insights" 
          description="Receive custom cognitive exercise recommendations based on specific behavioral data."
        />
        <FeatureItem 
          title="Privacy-Focused AI" 
          description="End-to-end encryption ensures all cognitive data is handled with maximum security."
        />
        <FeatureItem 
          title="Scalable Deployment" 
          description="Easy integration for clinics, care centers, and home monitoring solutions worldwide."
        />
        <FeatureItem 
          title="Ethical Data Usage" 
          description="Transparent AI modeling that prioritizes patient dignity and clinical accuracy."
        />
      </div>
    </Section>
  );
}
