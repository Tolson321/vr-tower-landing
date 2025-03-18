
import React from 'react';
import { motion } from 'framer-motion';
import { Star } from 'lucide-react';

const testimonials = [
  {
    quote: "The most immersive tower defense game I've ever played. The ability to physically walk around your defenses and interact with towers takes strategy to a whole new level.",
    author: "VR Gaming Monthly",
    rating: 5
  },
  {
    quote: "Defend The Realm perfectly translates the tower defense genre into VR. The tactile controls feel natural, and the strategic depth is impressive.",
    author: "Quest Gamer",
    rating: 5
  },
  {
    quote: "The attention to detail is astounding. From the particle effects to the enemy design, everything comes together to create a truly memorable VR experience.",
    author: "VR Enthusiast",
    rating: 4
  }
];

const TestimonialsSection = () => {
  return (
    <section className="relative py-24 overflow-hidden">
      {/* Background glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[70vw] h-[50vh] rounded-full bg-vr-purple/5 blur-[150px] pointer-events-none"></div>
      
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
            What Players Are Saying
          </motion.h2>
          <motion.div 
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="w-20 h-1 bg-gradient-to-r from-vr-purple to-vr-blue mx-auto mb-6"
          ></motion.div>
        </div>
        
        {/* Testimonials */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: 0.1 * index }}
              className="glass-card rounded-xl p-8 flex flex-col h-full"
            >
              {/* Stars */}
              <div className="flex mb-4">
                {[...Array(5)].map((_, i) => (
                  <Star 
                    key={i} 
                    size={18} 
                    className={i < testimonial.rating ? "fill-vr-purple text-vr-purple" : "text-gray-600"} 
                  />
                ))}
              </div>
              
              {/* Quote */}
              <blockquote className="mb-4 flex-grow">
                <p className="text-gray-300 italic">"{testimonial.quote}"</p>
              </blockquote>
              
              {/* Author */}
              <footer>
                <p className="font-semibold text-white">{testimonial.author}</p>
              </footer>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default TestimonialsSection;
