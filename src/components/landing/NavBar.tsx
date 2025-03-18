
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Menu, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

const NavBar = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  
  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);
  
  return (
    <>
      <header className={cn(
        "fixed top-0 left-0 right-0 z-50 transition-all duration-300",
        isScrolled ? "py-3 bg-vr-dark/80 backdrop-blur-lg shadow-lg" : "py-5 bg-transparent"
      )}>
        <div className="container max-w-6xl mx-auto px-4">
          <div className="flex items-center justify-between">
            {/* Logo */}
            <div className="flex items-center">
              <a href="#" className="text-xl font-display font-bold bg-clip-text text-transparent bg-gradient-to-r from-vr-purple-light to-vr-blue">
                DEFEND THE REALM
              </a>
            </div>
            
            {/* Desktop Navigation */}
            <nav className="hidden md:flex items-center space-x-8">
              {['Features', 'Gameplay', 'Testimonials'].map((item, index) => (
                <a 
                  key={index}
                  href={`#${item.toLowerCase()}`}
                  className="text-gray-300 hover:text-white transition-colors py-2"
                >
                  {item}
                </a>
              ))}
              <Button className="btn-3d bg-white/10 hover:bg-white/20 backdrop-blur-sm border border-white/20 text-white">
                Get it on Meta Quest
              </Button>
            </nav>
            
            {/* Mobile menu button */}
            <button 
              className="md:hidden flex items-center"
              onClick={() => setIsMobileMenuOpen(true)}
              aria-label="Open mobile menu"
            >
              <Menu className="w-6 h-6 text-white" />
            </button>
          </div>
        </div>
      </header>
      
      {/* Mobile menu */}
      <AnimatePresence>
        {isMobileMenuOpen && (
          <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-vr-dark/95 backdrop-blur-lg md:hidden"
          >
            <div className="relative h-full flex flex-col">
              {/* Close button */}
              <div className="flex justify-end p-4">
                <button
                  onClick={() => setIsMobileMenuOpen(false)}
                  aria-label="Close mobile menu"
                >
                  <X className="w-6 h-6 text-white" />
                </button>
              </div>
              
              {/* Mobile navigation */}
              <div className="flex flex-col items-center justify-center flex-grow gap-8">
                {['Features', 'Gameplay', 'Testimonials'].map((item, index) => (
                  <motion.a
                    key={index}
                    href={`#${item.toLowerCase()}`}
                    className="text-xl text-white"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.1 * index }}
                    onClick={() => setIsMobileMenuOpen(false)}
                  >
                    {item}
                  </motion.a>
                ))}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.4 }}
                >
                  <Button 
                    className="mt-4 bg-gradient-to-r from-vr-purple to-vr-blue text-white border-0"
                    onClick={() => setIsMobileMenuOpen(false)}
                  >
                    Get it on Meta Quest
                  </Button>
                </motion.div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};

export default NavBar;
