import Section from "./Section";
import { Hospital, Home, HeartPulse, Globe } from "lucide-react";

const UseCase = ({ icon: Icon, title, description }: any) => (
  <div className="flex flex-col items-center text-center p-8 bg-white/50 rounded-3xl border border-soft hover:bg-white transition-all">
    <div className="w-16 h-16 bg-soft rounded-full flex items-center justify-center text-primary mb-6"><Icon size={32} /></div>
    <h4 className="text-xl font-bold text-dark mb-2">{title}</h4>
    <p className="text-muted italic">{description}</p>
  </div>
);

export default function UseCases() {
  return (
    <Section id="use-cases">
      <h2 className="text-4xl md:text-5xl font-bold text-dark mb-16 text-center">Where It’s Used</h2>
      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
        <UseCase icon={Hospital} title="Clinics" description="Seamless baseline testing during routine checkups." />
        <UseCase icon={Home} title="Home Monitoring" description="Empowering families to track trends daily." />
        <UseCase icon={HeartPulse} title="Care Centers" description="Automated screening for elderly residents." />
        <UseCase icon={Globe} title="Rural Health" description="Deployable in areas with limited medical access." />
      </div>
    </Section>
  );
}
