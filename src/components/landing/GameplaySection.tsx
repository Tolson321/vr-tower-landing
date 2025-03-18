
import React, { useRef, useEffect } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';

const GameplaySection = () => {
  const sectionRef = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: sectionRef,
    offset: ["start end", "end start"]
  });
  
  const y = useTransform(scrollYProgress, [0, 1], [100, -100]);
  const opacity = useTransform(scrollYProgress, [0, 0.3, 0.6, 1], [0, 1, 1, 0]);

  return (
    <section ref={sectionRef} className="relative py-24 overflow-hidden bg-vr-darker-blue">
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
            Immersive Gameplay
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
            className="text-lg text-gray-300 max-w-2xl mx-auto mb-12"
          >
            Step into a world where you are the commander. Build, fight and defend in a fully immersive VR environment.
          </motion.p>
        </div>
        
        {/* Gameplay showcase */}
        <div className="relative">
          {/* Main gameplay image with parallax effect */}
          <motion.div 
            style={{ y, opacity }}
            className="relative z-10 rounded-xl overflow-hidden shadow-2xl border border-white/10 mx-auto max-w-4xl"
          >
            <img 
              src="https://images.unsplash.com/photo-1605810230434-7631ac76ec81" 
              alt="VR Tower Defense Gameplay" 
              className="w-full h-auto object-cover"
              loading="lazy"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-vr-darker-blue via-transparent to-transparent"></div>
            
            {/* Play button overlay */}
            <div className="absolute inset-0 flex items-center justify-center">
              <motion.div 
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                className="w-20 h-20 rounded-full bg-vr-purple/80 flex items-center justify-center cursor-pointer backdrop-blur-sm border border-white/20 shadow-lg shadow-vr-purple/30"
              >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M5 3L19 12L5 21V3Z" fill="white" />
                </svg>
              </motion.div>
            </div>
          </motion.div>
          
          {/* Floating detail cards */}
          <motion.div 
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.4 }}
            className="absolute top-1/4 left-0 lg:-left-8 glass-card p-4 rounded-lg max-w-[250px] z-20 hidden md:block"
          >
            <h4 className="text-sm font-semibold text-white mb-1">Tactical Map View</h4>
            <p className="text-xs text-gray-300">Command your defenses from a strategic overview or zoom in for direct control</p>
          </motion.div>
          
          <motion.div 
            initial={{ opacity: 0, x: 50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.6 }}
            className="absolute bottom-1/4 right-0 lg:-right-8 glass-card p-4 rounded-lg max-w-[250px] z-20 hidden md:block"
          >
            <h4 className="text-sm font-semibold text-white mb-1">Real-time Combat</h4>
            <p className="text-xs text-gray-300">Feel the intensity of battle with haptic feedback as enemies attack your defenses</p>
          </motion.div>
        </div>
        
        {/* Stats cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-16">
          {[
            { number: "12+", label: "Unique Tower Types" },
            { number: "30+", label: "Challenging Levels" },
            { number: "50+", label: "Hours of Gameplay" }
          ].map((stat, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: 0.2 * index }}
              className="glass-card rounded-lg p-6 text-center"
            >
              <div className="text-4xl font-display font-bold bg-clip-text text-transparent bg-gradient-to-r from-vr-purple-light to-vr-blue mb-2">
                {stat.number}
              </div>
              <div className="text-gray-300">{stat.label}</div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default GameplaySection;
