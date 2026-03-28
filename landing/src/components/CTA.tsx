import Section from "./Section";

export default function CTA() {
  return (
    <Section className="mb-24">
      <div className="bg-primary p-12 md:p-24 rounded-[3.5rem] text-center text-white soft-shadow-lg flex flex-col items-center">
        <h2 className="text-4xl md:text-6xl font-black mb-8 leading-tight">Start Early. Act Smarter.</h2>
        <p className="text-xl md:text-2xl opacity-90 mb-12 max-w-2xl font-medium">Join the thousands of caregivers and clinics building the future of cognitive healthcare with AI.</p>
        <button className="bg-accent hover:bg-accent/90 text-white px-12 py-5 rounded-2xl font-bold text-xl transition-transform hover:scale-105 shadow-2xl shadow-black/20">
          Try Cogniscan Free
        </button>
      </div>
    </Section>
  );
}
