import Section from "./Section";

export default function Impact() {
  return (
    <Section className="text-center" id="impact">
      <h2 className="text-4xl md:text-5xl font-bold text-dark mb-8">Why Early Detection Matters</h2>
      <p className="text-xl text-muted max-w-2xl mx-auto mb-16 italic">
        "Early detection can significantly slow progression and improve the quality of life for millions."
      </p>
      
      <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
        <div className="p-12 bg-soft/10 border-2 border-soft rounded-[2.5rem] flex flex-col items-center">
          <span className="text-6xl font-black text-primary mb-4">55M</span>
          <p className="text-dark font-bold text-lg">People worldwide living with dementia</p>
        </div>
        <div className="p-12 bg-primary text-white rounded-[2.5rem] flex flex-col items-center shadow-xl shadow-primary/20">
          <span className="text-6xl font-black mb-4">75%</span>
          <p className="font-bold text-lg opacity-90">Are diagnosed in late stages or not at all</p>
        </div>
        <div className="p-12 bg-soft/10 border-2 border-soft rounded-[2.5rem] flex flex-col items-center">
          <span className="text-6xl font-black text-primary mb-4">15s</span>
          <p className="text-dark font-bold text-lg text-center">Average time for AI to generate a baseline shift alert</p>
        </div>
      </div>
    </Section>
  );
}
