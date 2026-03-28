export default function Footer() {
  return (
    <footer className="bg-white border-t border-soft py-16 px-6 md:px-12">
      <div className="max-w-7xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-12 mb-12">
        <div>
          <h4 className="font-bold text-dark mb-6">Cogniscan</h4>
          <p className="text-muted text-sm leading-relaxed">AI-based early detection system for the future of cognitive health.</p>
        </div>
        <div>
          <h5 className="font-bold text-dark mb-6 text-sm uppercase tracking-widest">Platform</h5>
          <ul className="space-y-4 text-muted text-sm">
            <li><a href="#" className="hover:text-primary transition-colors">How it Works</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Features</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Use Cases</a></li>
          </ul>
        </div>
        <div>
          <h5 className="font-bold text-dark mb-6 text-sm uppercase tracking-widest">Company</h5>
          <ul className="space-y-4 text-muted text-sm">
            <li><a href="#" className="hover:text-primary transition-colors">About Us</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Contact</a></li>
            <li><a href="#" className="hover:text-primary transition-colors">Privacy Policy</a></li>
          </ul>
        </div>
        <div>
          <h5 className="font-bold text-dark mb-6 text-sm uppercase tracking-widest">Social</h5>
          <ul className="space-y-4 text-muted text-sm font-medium">
            <li><a href="#" className="hover:text-primary transition-colors italic">Twitter</a></li>
            <li><a href="#" className="hover:text-primary transition-colors italic">LinkedIn</a></li>
          </ul>
        </div>
      </div>
      <div className="max-w-7xl mx-auto pt-8 border-t border-soft text-center text-muted/60 text-xs">
        &copy; {new Date().getFullYear()} Cogniscan AI. All rights reserved.
      </div>
    </footer>
  );
}
