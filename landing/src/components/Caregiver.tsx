import Section from "./Section";
import { Heart, Bell, Eye, Zap } from "lucide-react";

export default function Caregiver() {
  return (
    <Section className="grid lg:grid-cols-2 gap-20 items-center justify-center p-12 bg-white rounded-[3rem] my-12" id="caregiver">
      <div className="relative">
        <div className="absolute -top-10 -left-10 w-40 h-40 bg-soft rounded-full -z-10 animate-pulse" />
        <div className="h-[400px] w-full bg-soft/50 rounded-3xl border-2 border-primary/20 flex items-center justify-center text-primary/30">
          <Heart size={120} strokeWidth={1} />
        </div>
      </div>
      
      <div>
        <h2 className="text-4xl md:text-5xl font-bold text-dark mb-8">Supporting Caregivers, Empowering Patients</h2>
        <div className="space-y-8">
          <div className="flex gap-6">
            <div className="p-3 bg-soft rounded-xl text-primary flex-shrink-0"><Bell size={24} /></div>
            <div>
              <h4 className="text-xl font-bold text-dark mb-1">Instant Alerts</h4>
              <p className="text-muted">No more guesswork. Get proactive notifications when behavioral patterns shift.</p>
            </div>
          </div>
          <div className="flex gap-6">
            <div className="p-3 bg-soft rounded-xl text-primary flex-shrink-0"><Eye size={24} /></div>
            <div>
              <h4 className="text-xl font-bold text-dark mb-1">Deep Insights</h4>
              <p className="text-muted">Access visual reports that translate complex AI data into simple medical trends.</p>
            </div>
          </div>
          <div className="flex gap-6">
            <div className="p-3 bg-soft rounded-xl text-primary flex-shrink-0"><Zap size={24} /></div>
            <div>
              <h4 className="text-xl font-bold text-dark mb-1">Empowered Action</h4>
              <p className="text-muted">Equip your doctors with better data, enabling precise and early interventions.</p>
            </div>
          </div>
        </div>
      </div>
    </Section>
  );
}
