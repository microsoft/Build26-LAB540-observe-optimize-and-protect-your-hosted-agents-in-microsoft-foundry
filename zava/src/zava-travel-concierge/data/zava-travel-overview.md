# Zava Travel — Company Overview & Destination Guide

## About Zava Travel

**Zava Travel** is a premium travel agency specializing in international travel experiences. We connect travelers with the world's most exciting destinations through a seamless booking experience that includes **flights**, **hotels**, and **car rentals** — all in one place.

### Our Mission
To make international travel accessible, enjoyable, and stress-free for every traveler — whether you're a solo backpacker, a business professional, a couple on a romantic getaway, or a family on vacation.

### Our Services
- ✈️ **Flights** — 20 flights across 5 route pairs with 5 airline partners
- 🏨 **Hotels** — 15 properties across 5 cities, from budget hostels to 5-star luxury
- 🚗 **Car Rentals** — 15 rental options across 5 cities with 6 rental partners
- 🤖 **Zava Travel Concierge** — Our AI-powered concierge orchestrates dedicated flight, hotel, and car rental agents to plan and book complete itineraries on your behalf

### How the Zava Travel Concierge Works

The **Zava Travel Concierge** is the single agent travelers talk to. Behind the scenes it coordinates a small team of specialist agents — each owning one part of the trip — and stitches their answers together into one itinerary.

| Agent | Role | Data Source |
|---|---|---|
| **Zava Travel Concierge** (orchestrator) | Understands the traveler's intent, decomposes the request, delegates to specialists, and assembles the final itinerary | Conversation + specialist agent responses |
| **Flight Agent** | Searches routes, compares cabin classes and prices, and recommends outbound/return flights | `flights.csv` / `flights.md` |
| **Hotel Agent** | Filters hotels by city, star rating, amenities, and budget; recommends a property per night | `hotels.csv` / `hotels.md` |
| **Car Rental Agent** | Matches vehicles to traveler needs (economy, SUV, luxury, minivan), pickup/return dates, and city | `car_rentals.csv` / `car_rentals.md` |

**Example flow** — *"Plan a trip from Chicago to Rome with hotel and car rental for the first two weeks of November."*

1. The **Concierge** parses the request (origin, destination, dates, components needed).
2. It calls the **Flight Agent** for Chicago ↔ Rome options on the requested dates.
3. It calls the **Hotel Agent** for Rome properties available across those nights.
4. It calls the **Car Rental Agent** for Rome pickups during the same window.
5. It composes a single itinerary response with the recommended flight, hotel, and car — plus alternatives.

This pattern keeps each specialist agent focused, makes each tool call easy to evaluate independently, and lets the Concierge handle the cross-cutting reasoning (budgets, trade-offs, traveler preferences).

### Our Destinations

| Destination | Country | Best Season | Highlight |
|------------|---------|-------------|-----------|
| Paris | France | Spring/Summer | Art, cuisine, romance |
| London | United Kingdom | Spring/Fall | History, theater, culture |
| Tokyo | Japan | Fall (Oct) | Tradition meets technology |
| Rome | Italy | Fall (Nov) | Ancient history, food, art |
| Cancún | Mexico | Winter (Dec) | Beach, ruins, nightlife |

---

## Destination Guides

### 🇫🇷 Paris, France

**Why Paris?** The City of Light is the world's most visited city — and for good reason. From the Eiffel Tower to the Louvre, from Michelin-starred restaurants to sidewalk crêperies, Paris is a feast for all senses.

**Must-See Attractions:**
- Eiffel Tower — Iconic iron lattice tower, best at sunset
- Louvre Museum — Home to the Mona Lisa and 35,000+ artworks
- Notre-Dame Cathedral — Gothic masterpiece (exterior view during restoration)
- Montmartre & Sacré-Cœur — Artistic hilltop neighborhood with panoramic views
- Champs-Élysées & Arc de Triomphe — Paris's grand boulevard
- Versailles Palace — Opulent royal estate (30 min by train)

**Local Tips:**
- The Paris Museum Pass saves money if visiting 3+ museums
- Metro is the fastest way around — buy a carnet of 10 tickets
- Tipping is included in restaurant bills (service compris) but rounding up is appreciated
- Most shops close on Sundays
- Learn a few French phrases — locals appreciate the effort

**Weather (August):** Warm and sunny, 65–80°F (18–27°C). Occasional afternoon thunderstorms. Light layers recommended.

**Currency:** Euro (€). Credit cards widely accepted.

---

### 🇬🇧 London, United Kingdom

**Why London?** A city where Buckingham Palace stands alongside cutting-edge skyscrapers, where Shakespearean theater coexists with West End musicals, and where you can eat cuisine from every corner of the world.

**Must-See Attractions:**
- Tower of London — 1,000 years of history, home of the Crown Jewels
- British Museum — Free admission, world-class antiquities
- Buckingham Palace — Watch the Changing of the Guard
- Westminster Abbey & Big Ben — Iconic parliamentary district
- Camden Market — Eclectic food, fashion, and culture
- Harry Potter Studio Tour — Wizarding World experience (book ahead!)

**Local Tips:**
- Get an Oyster card or use contactless payment for the Tube
- Afternoon tea is a must-do experience (book at The Ritz or Fortnum & Mason)
- Pubs close at 11 PM on weekdays — plan accordingly
- The weather is unpredictable — always carry an umbrella
- "Queue" is sacred — never cut in line

**Weather (September):** Mild and pleasant, 55–68°F (13–20°C). Rain is common — waterproof jacket essential.

**Currency:** British Pound Sterling (£). Contactless payment is ubiquitous.

---

### 🇯🇵 Tokyo, Japan

**Why Tokyo?** A city of contrasts where ancient Shinto shrines sit beneath neon skyscrapers, where centuries-old tea ceremonies coexist with robot restaurants, and where the food is simply extraordinary.

**Must-See Attractions:**
- Sensō-ji Temple — Tokyo's oldest and most famous Buddhist temple in Asakusa
- Shibuya Crossing — The world's busiest pedestrian intersection
- Meiji Shrine — Serene Shinto shrine in a forested park
- Tsukiji Outer Market — Fresh sushi, seafood, and street food
- Akihabara — Electronics, anime, and gaming paradise
- Mount Fuji Day Trip — Japan's iconic peak (2 hours by train)

**Local Tips:**
- Get a Suica or Pasmo card for seamless public transit
- Tipping is NOT customary and can be considered rude
- Remove shoes when entering homes, temples, and some restaurants
- Convenience stores (konbini) are incredible — great food, ATMs, and services 24/7
- Trains are extremely punctual — being late is unacceptable
- Cash is still king in many smaller establishments

**Weather (October):** Comfortable autumn weather, 55–72°F (13–22°C). Fall foliage begins late October. Light jacket recommended.

**Currency:** Japanese Yen (¥). Cash is widely preferred; some places don't accept cards.

---

### 🇮🇹 Rome, Italy

**Why Rome?** The Eternal City is a living museum where every street tells a story spanning 2,800 years. Roman ruins, Renaissance art, Vatican treasures, and the world's best pasta — all in one city.

**Must-See Attractions:**
- Colosseum — Ancient gladiatorial arena, Rome's most iconic landmark
- Vatican Museums & Sistine Chapel — Michelangelo's masterpiece ceiling
- St. Peter's Basilica — The world's largest church, heart of Catholicism
- Roman Forum — Center of ancient Roman public life
- Trevi Fountain — Toss a coin to ensure your return to Rome
- Pantheon — Best-preserved ancient Roman building, free admission

**Local Tips:**
- Book Vatican tickets online weeks in advance — the line can be 3+ hours
- Aperitivo (pre-dinner drinks with free snacks) is a daily ritual, usually 6–8 PM
- Avoid restaurants with picture menus near tourist sites — they're tourist traps
- Dress modestly when visiting churches (cover shoulders and knees)
- The "coperto" (cover charge) on restaurant bills is normal and legal

**Weather (November):** Cool and mild, 45–60°F (7–16°C). Occasional rain. Fewer tourists than summer. Layered clothing recommended.

**Currency:** Euro (€). Credit cards accepted at most restaurants and shops.

---

### 🇲🇽 Cancún, Mexico

**Why Cancún?** Turquoise Caribbean waters, white-sand beaches, ancient Mayan ruins, and a vibrant nightlife scene — Cancún is the ultimate beach vacation destination with cultural depth.

**Must-See Attractions:**
- Chichén Itzá — One of the New Seven Wonders of the World (2.5-hour drive)
- Tulum Ruins — Clifftop Mayan ruins overlooking the Caribbean
- Cenotes — Natural swimming holes in limestone sinkholes (Ik Kil, Dos Ojos)
- Isla Mujeres — Laid-back island, 20-minute ferry from Cancún
- Xcaret Park — Eco-archaeological park with snorkeling, wildlife, and cultural shows
- Cancún Underwater Museum (MUSA) — Submerged art installations for snorkelers and divers

**Local Tips:**
- Negotiate prices at markets — it's expected and part of the culture
- Drink bottled water only — avoid ice from unknown sources
- The Hotel Zone and Downtown (Centro) offer very different experiences and prices
- Book excursions through your hotel or reputable companies — avoid beach vendors
- Sunscreen is essential — the Caribbean sun is intense even on cloudy days
- Some cenotes and eco-parks require biodegradable sunscreen only

**Weather (December):** Warm and sunny, 70–85°F (21–29°C). Dry season — perfect beach weather. Brief afternoon showers possible.

**Currency:** Mexican Peso (MXN). US dollars accepted in the Hotel Zone, but you'll get better rates with pesos.

---

## Zava Travel Policies

### Booking
- All bookings can be made through the **Zava Travel Concierge** or directly with a human advisor
- Prices are subject to change based on availability
- Full payment is required at the time of booking for flights; hotels and cars require a deposit

### Cancellation
- Flights: Cancellation fees vary by airline and fare class (typically $50–200)
- Hotels: Free cancellation up to 48 hours before check-in for most properties
- Car Rentals: Free cancellation up to 24 hours before pickup

### Customer Support
- 24/7 support available through the **Zava Travel Concierge**
- Human advisors available Mon–Fri, 9 AM – 6 PM (PST)
- Emergency travel assistance available 24/7 for active bookings

### Loyalty Program
- Zava Travel Rewards members earn 1 point per $1 spent
- Points can be redeemed for upgrades, free nights, and flight discounts
- Silver status at 5,000 points/year; Gold status at 15,000 points/year
