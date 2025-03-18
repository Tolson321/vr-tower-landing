
import React from 'react';
import { motion } from 'framer-motion';
import { Button } from '@/components/ui/button';
import { VrHeadset } from 'lucide-react';

const CTASection = () => {
  return (
    <section className="py-24 relative overflow-hidden">
      {/* Background elements */}
      <div className="absolute inset-0 bg-vr-darker-blue"></div>
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(139,92,246,0.15),transparent_70%)]"></div>
      <div className="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-vr-purple/30 to-transparent"></div>
      
      <div className="container max-w-6xl mx-auto px-4 relative z-10">
        <motion.div 
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="glass-card rounded-2xl overflow-hidden"
        >
          <div className="relative p-8 md:p-12 lg:p-16 flex flex-col items-center text-center">
            {/* Circular glow */}
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-64 h-64 rounded-full bg-vr-purple/20 blur-[100px] pointer-events-none"></div>
            
            <VrHeadset size={48} className="text-vr-purple mb-6" />
            
            <motion.h2 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: 0.2 }}
              className="text-3xl md:text-4xl lg:text-5xl font-display font-bold mb-4 bg-clip-text text-transparent bg-gradient-to-r from-white to-gray-300"
            >
              Ready to Defend the Realm?
            </motion.h2>
            
            <motion.p 
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: 0.3 }}
              className="text-lg text-gray-300 max-w-2xl mb-8"
            >
              Jump into the most immersive tower defense experience ever created. Available exclusively on Meta Quest.
            </motion.p>
            
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: 0.4 }}
            >
              <Button size="lg" className="btn-3d bg-gradient-to-r from-vr-purple to-vr-blue text-white border-0 px-8 py-6 text-lg font-semibold shadow-lg shadow-vr-purple/20 hover:shadow-vr-purple/40">
                Get it on Meta Quest
              </Button>
            </motion.div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default CTASection;
