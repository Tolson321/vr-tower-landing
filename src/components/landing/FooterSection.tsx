
import React from 'react';
import { Facebook, Instagram, Twitter, Youtube } from 'lucide-react';

const FooterSection = () => {
  return (
    <footer className="py-12 relative overflow-hidden">
      <div className="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-vr-purple/30 to-transparent"></div>
      
      <div className="container max-w-6xl mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-between items-center mb-8">
          {/* Logo */}
          <div className="mb-6 md:mb-0">
            <h2 className="text-2xl font-display font-bold bg-clip-text text-transparent bg-gradient-to-r from-vr-purple-light to-vr-blue">
              DEFEND THE REALM
            </h2>
          </div>
          
          {/* Social links */}
          <div className="flex space-x-4">
            {[
              { icon: <Facebook size={20} />, label: "Facebook" },
              { icon: <Twitter size={20} />, label: "Twitter" },
              { icon: <Instagram size={20} />, label: "Instagram" },
              { icon: <Youtube size={20} />, label: "YouTube" }
            ].map((social, index) => (
              <a 
                key={index}
                href="#" 
                aria-label={social.label}
                className="w-10 h-10 rounded-full flex items-center justify-center bg-white/5 border border-white/10 hover:bg-white/10 transition-colors"
              >
                {social.icon}
              </a>
            ))}
          </div>
        </div>
        
        {/* Navigation */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-8">
          {[
            {
              title: "Game",
              links: ["Features", "Gameplay", "Updates", "Roadmap"]
            },
            {
              title: "Support",
              links: ["FAQ", "Contact", "Tutorials", "Requirements"]
            },
            {
              title: "Company",
              links: ["About Us", "Careers", "Press Kit", "Blog"]
            },
            {
              title: "Legal",
              links: ["Terms", "Privacy", "Cookies", "Licenses"]
            }
          ].map((column, colIndex) => (
            <div key={colIndex}>
              <h3 className="text-white font-semibold mb-4">{column.title}</h3>
              <ul className="space-y-2">
                {column.links.map((link, linkIndex) => (
                  <li key={linkIndex}>
                    <a href="#" className="text-gray-400 hover:text-white transition-colors">
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
        
        {/* Bottom bar */}
        <div className="pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400 text-sm mb-4 md:mb-0">
            © 2023 Defend The Realm. All rights reserved. Meta Quest is a trademark of Meta Platforms, Inc.
          </p>
          <div className="text-sm text-gray-400">
            Made with 💜 for VR enthusiasts
          </div>
        </div>
      </div>
    </footer>
  );
};

export default FooterSection;
