
import React from 'react';
import { motion } from 'framer-motion';
import { Shield, Target, Gamepad, Zap, Headset, Crosshair } from 'lucide-react';
import { cn } from '@/lib/utils';

const features = [
  {
    icon: <Shield className="w-10 h-10 text-vr-purple" />,
    title: "Strategic Defense Planning",
    description: "Deploy towers, traps, and barriers with intuitive VR controls. Every decision shapes your defensive strategy.",
    color: "from-vr-purple/20 to-vr-purple/5"
  },
  {
    icon: <Target className="w-10 h-10 text-vr-blue" />,
    title: "Enemy Wave Intelligence",
    description: "Face increasingly challenging enemies with adaptive AI that responds to your tactics and strategy.",
    color: "from-vr-blue/20 to-vr-blue/5"
  },
  {
    icon: <Gamepad className="w-10 h-10 text-vr-purple-light" />,
    title: "Intuitive Controls",
    description: "Natural gesture controls for building, upgrading, and tactically responding to threats in real-time.",
    color: "from-vr-purple-light/20 to-vr-purple-light/5"
  },
  {
    icon: <Zap className="w-10 h-10 text-vr-blue" />,
    title: "Tower Upgrades & Abilities",
    description: "Research and unlock powerful tower upgrades and special abilities to enhance your defensive capabilities.",
    color: "from-vr-blue/20 to-vr-blue/5"
  },
  {
    icon: <Headset className="w-10 h-10 text-vr-purple" />,
    title: "Full 360° Immersion",
    description: "Experience battles from any angle with complete freedom to move and interact with your defenses.",
    color: "from-vr-purple/20 to-vr-purple/5"
  },
  {
    icon: <Crosshair className="w-10 h-10 text-vr-purple-light" />,
    title: "Precision Targeting",
    description: "Take direct control of special weapons for precision targeting during critical moments in battle.",
    color: "from-vr-purple-light/20 to-vr-purple-light/5"
  }
];

const FeaturesSection = () => {
  return (
    <section id="features" className="relative py-24 overflow-hidden">
      {/* Background elements */}
      <div className="absolute inset-0 bg-feature-grid opacity-30"></div>
      
      <div className="container max-w-6xl mx-auto px-4">
        {/* Section header */}
        <div className="text-center mb-16">
          <motion.h2 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="text-3xl md:text-4xl font-display font-bold mb-4"
          >
            Game Features
          </motion.h2>
          <motion.div 
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="w-20 h-1 bg-gradient-to-r from-vr-purple to-vr-blue mx-auto mb-6"
          ></motion.div>
          <motion.p 
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.3 }}
            className="text-lg text-gray-300 max-w-2xl mx-auto"
          >
            Experience tower defense like never before with our innovative VR gameplay mechanics
          </motion.p>
        </div>
        
        {/* Features grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: 0.1 * index }}
              className={cn(
                "glass-card rounded-xl p-6 backdrop-blur-md hover:translate-y-[-4px] transition-all duration-300",
                "border border-white/10 hover:border-white/20",
                "bg-gradient-to-br", feature.color
              )}
            >
              <div className="mb-4">{feature.icon}</div>
              <h3 className="text-xl font-display font-semibold mb-3">{feature.title}</h3>
              <p className="text-gray-300">{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
