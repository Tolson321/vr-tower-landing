
import React from 'react';
import { motion } from 'framer-motion';
import { ChevronDown, Gamepad, Shield, VrHeadset } from 'lucide-react';
import { Button } from '@/components/ui/button';

const HeroSection = () => {
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-4 overflow-hidden">
      {/* Background elements */}
      <div className="absolute inset-0 bg-hero-pattern opacity-70"></div>
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[50vw] h-[50vw] rounded-full bg-vr-purple/10 blur-[100px] pointer-events-none"></div>
      
      {/* Content container */}
      <div className="container relative z-10 max-w-6xl mx-auto text-center">
        {/* Top badge */}
        <motion.div 
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="inline-block mb-6"
        >
          <span className="px-4 py-1.5 rounded-full bg-vr-purple/20 border border-vr-purple/30 text-sm font-medium text-vr-purple-light inline-flex items-center">
            <VrHeadset size={16} className="mr-2" />
            Meta Quest Exclusive
          </span>
        </motion.div>
        
        {/* Main heading */}
        <motion.h1 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="text-4xl md:text-6xl lg:text-7xl font-display font-bold tracking-tight mb-6"
        >
          <span className="bg-clip-text text-transparent bg-gradient-to-r from-vr-purple-light to-vr-blue">
            DEFEND THE REALM
          </span>
          <br />
          <span className="text-white">VR Tower Defense</span>
        </motion.h1>
        
        {/* Subtitle */}
        <motion.p 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.4 }}
          className="text-lg md:text-xl text-gray-300 max-w-2xl mx-auto mb-8 leading-relaxed"
        >
          Immerse yourself in a breathtaking virtual reality world where strategy meets action. Build, upgrade, and defend against waves of enemies in the most immersive tower defense experience ever created.
        </motion.p>
        
        {/* CTA buttons */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          className="flex flex-col sm:flex-row gap-4 justify-center mb-12"
        >
          <Button size="lg" className="btn-3d bg-gradient-to-r from-vr-purple to-vr-blue text-white border-0 px-8 py-6 text-lg font-semibold shadow-lg shadow-vr-purple/20 hover:shadow-vr-purple/40 animate-glow-pulse">
            Get it on Meta Quest
          </Button>
          <Button size="lg" variant="outline" className="btn-3d border border-white/20 bg-white/5 backdrop-blur-sm hover:bg-white/10 text-white px-8 py-6 text-lg font-semibold">
            Watch Trailer
          </Button>
        </motion.div>
        
        {/* Feature badges */}
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.8 }}
          className="flex flex-wrap justify-center gap-4 md:gap-8 mb-12"
        >
          {[
            { icon: <Shield size={18} className="mr-2" />, text: "Strategic Gameplay" },
            { icon: <Gamepad size={18} className="mr-2" />, text: "Full VR Immersion" },
            { icon: <VrHeadset size={18} className="mr-2" />, text: "Meta Quest Optimized" }
          ].map((feature, index) => (
            <div key={index} className="flex items-center px-4 py-2 rounded-full bg-white/5 backdrop-blur-sm border border-white/10">
              {feature.icon}
              <span className="text-sm text-gray-200">{feature.text}</span>
            </div>
          ))}
        </motion.div>
        
        {/* Scroll indicator */}
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 1 }}
          className="absolute bottom-8 left-1/2 transform -translate-x-1/2 flex flex-col items-center"
        >
          <span className="text-gray-400 text-sm mb-2">Scroll to explore</span>
          <ChevronDown size={24} className="text-gray-400 animate-bounce" />
        </motion.div>
      </div>
      
      {/* Decorative gradient line */}
      <div className="gradient-line absolute bottom-0"></div>
    </section>
  );
};

export default HeroSection;
