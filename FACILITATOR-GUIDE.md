# Facilitator Guide: Getting Started with Vibe Coding in Business Central

This guide helps you run the workshop for your team or at events.

## Workshop Overview

**Duration:** 105 minutes
**Format:** Interactive with live code review demonstrations
**Audience:** BC developers of all levels
**Goal:** Demonstrate AI's strength in review through progressive catch rates 

---

## Pre-Workshop Preparation (1-2 Weeks Before)

### 1. Participant Communications

**Email participants 3-5 days before:**

Subject: Workshop Setup - Getting Started with Vibe Coding in BC

```
Hi [team],

Looking forward to the "Vibe Coding in Business Central" workshop!

Please complete setup before we meet:
1. VS Code with AL Language extension installed
2. GitHub Copilot + Copilot Chat extensions (recommended)
3. Clone repository (with submodules): git clone --recurse-submodules https://github.com/JeremyVyska/DirectionsEmea2025-Workshop.git
4. Follow SETUP.md for BC sandbox connection

Optional: Install BC Code Intelligence MCP (instructions in SETUP.md)
Note: Workshop works fine without MCP - we have a fallback.

See you at the workshop!
```

### 2. Technical Setup

**Verify you have:**
- [ ] BC sandbox environment for demos (or use local Docker)
- [ ] Workshop repository cloned
- [ ] Demo scenarios tested on all 3 stages
- [ ] Solution branches created (stage1-solution, stage2-solution, stage3-solution)
- [ ] Backup plan if BC sandbox has issues (screenshots, pre-recorded demo)

**Create solution branches:**
```bash
# Complete Stage 1 exercise implementation
git checkout -b stage1-solution
# [implement maintenance status with autocomplete gaps]
git add . && git commit -m "Stage 1 solution: autocomplete baseline"

# Complete Stage 2 exercise (improved version)
git checkout -b stage2-solution
# [implement with planning, better quality]
git add . && git commit -m "Stage 2 solution: agentic planning"

# Complete Stage 3 exercise (full agentic)
git checkout -b stage3-solution
# [implement with cross-layer + knowledge + testing]
git add . && git commit -m "Stage 3 solution: complete agentic"

# Create starting points for each stage
git branch stage1-start main
git branch stage2-start stage1-solution
git branch stage3-start stage2-solution
```

### 3. Presentation Materials

**Prepare:**
- [ ] Slide deck (intro + stage transitions)
- [ ] Demo environment tested and ready
- [ ] Code editor with good font size for screen sharing
- [ ] Timer for exercise segments
- [ ] Backup plan (offline slides, pre-recorded demos)

---

## Workshop Timeline

### Setup & Introduction (10 min)

**0:00-0:05 - Welcome & Setup Check**
- "Can everyone see the repository in VS Code?"
- "Quick show of hands: Who has GitHub Copilot installed?"
- "Who installed BC Code Intelligence MCP?" (acknowledge, move on)

**0:05-0:10 - Workshop Goals**
- "Let's talk about what AI is really good for in software development"
- "Development isn't just coding - it's performance, security, UX, extensibility, telemetry, documentation..."
- "Developers are strong at coding. But time pressure means we skip or miss other dimensions."
- "Today we prove: Agentic AI excels at comprehensive review across the full software lifecycle"
- "We'll test generic AI (catches common issues) vs BC specialists (catches significantly more across all dimensions)"
- Show architecture diagram (2 layers, 5 apps with 30 anti-patterns spanning all quality dimensions)
- "AmuseYou business context: bounce units + go-karts"

---

### Stage 1: Baseline - Your First AI Feature (22 min)

**0:10-0:18 - Demo (8 min)**
- Follow [Stage1-Baseline/demo-script.md](Stage1-Baseline/demo-script.md)
- Live code with AI: Add discount field in ~10 seconds
- Show it compiles and works
- Brief "Wait..." moment: What did we NOT think about?
- **Key message:** "AI writes code fast! But working ≠ production-ready"
- **Energy:** Keep it fun and magical - this is the 'hello world' moment!

**0:18-0:29 - Participant Exercise (11 min)**
- Participants pick one simple feature (Customer Email, Equipment Status, or Booking Notes)
- They ask AI, accept suggestions, see it work
- Emphasize: "Just experience AI coding - don't overthink it!"
- **Walk around:** Help stuck participants, celebrate successes
- **Key message:** "You just coded with AI! That's the vibe!"

**0:29-0:32 - Transition to Stage 2 (3 min)**
- "That was fast and fun! But now let's ask: What did we miss?"
- "In Stage 2, we'll ask AI to *review* what we just built"
- "Can AI catch its own shortcuts? Let's find out!"

---

### Stage 2: Basic AI Review - Generic Copilot (28 min)

**0:32-0:42 - Demo: Generic AI Review (10 min)**
- Follow [Stage2-Planning/demo-script.md](Stage2-Planning/demo-script.md)
- Prompt: "Review this codebase for issues and suggest improvements"
- Show what generic Copilot catches (Easy wins: BEGIN..END, naming conventions)
- Show what it misses across dimensions:
  - Performance: Doesn't understand SIFT keys or BC query patterns
  - Security: Doesn't flag missing permission sets
  - UX: Doesn't know BC Role Center requirements
  - Extensibility: Doesn't suggest integration events
- **Key message:** "Generic AI catches common issues - strong at code style, weak at BC-specific quality dimensions"

**0:42-0:57 - Live Testing with Participants (15 min)**
- "Everyone: Ask your generic AI to review BookingMgt.Codeunit.al"
- Track findings on shared doc/whiteboard
- Count catch rate together
- **Walk around:** Help with prompts, observe patterns

**0:57-1:00 - Debrief (3 min)**
- "How many issues did generic AI catch?"
- "What BC-specific patterns did it miss?"
- "This demonstrates the limits of file-based grounding without domain knowledge"

---

### Stage 3: Knowledge-Enhanced Review - MCP Specialists (40 min)

**1:00-1:12 - Demo: Dean Debug (Performance Review) (12 min)**
- Follow [Stage3-Complete/demo-script.md](Stage3-Complete/demo-script.md)
- Prompt: "Dean, review this app for performance issues"
- Show Dean catches what developers miss under time pressure:
  - Missing SIFT keys (10-100x slower queries)
  - Commit anti-pattern (90% wasted transaction overhead)
  - N+1 queries, no HttpClient reuse
  - Missing telemetry for production troubleshooting
- Show detailed recommendations with performance metrics
- **Key message:** "Performance dimension covered comprehensively"

**1:12-1:20 - Demo: Roger, Uma, Jordan (8 min)**
- Roger (Security & Quality): Permission sets missing (AppSource blocker), code quality issues
- Uma (UX): No Role Center, actions not promoted, no FactBoxes, poor field organization
- Jordan (Extensibility & Support): No integration events, no retry logic, no structured error handling
- **Key message:** "Each specialist covers a quality dimension developers often skip"

**1:20-1:37 - Participant Testing (17 min)**
- "Ask Dean/Roger/Uma/Jordan to review your code"
- Compare findings to Stage 2 generic review
- Track catch rate on shared doc
- **Walk around:** Help with MCP prompts, discuss findings

**1:37-1:40 - Debrief (3 min)**
- "How much better did the specialists perform?"
- "Which quality dimensions did generic AI completely miss?"
- "Performance, security, UX, extensibility - all covered comprehensively by specialists"
- "This substantial improvement is why AI augments developers across the full software lifecycle"

---

### Wrap-up & Next Steps (5 min)

**1:40-1:45 - Summary**
- "What we proved today: AI excels at comprehensive review across all quality dimensions"
- "Developers are strong at coding. AI is stronger at catching performance, security, UX, extensibility issues."
- "Generic AI catches common issues | BC specialists catch significantly more across all dimensions"
- "Substantial improvement because specialists cover dimensions you don't have time for"
- "This isn't about replacing developers - it's about being production-ready faster"
- "Take this repo + MCP back to your team as a quality multiplier"
- Q&A buffer

---

## Facilitation Tips

### Managing Time

**If running behind:**
- Stage 1: Cut exercise to 8 min, extend debrief
- Stage 2: Cut exercise to 12 min
- Stage 3: Combine demo parts (15 min total), cut exercise to 15 min

**If running ahead:**
- Stage 1: Deeper debrief - compare specific code examples
- Stage 2: Show planning template variations
- Stage 3: Live Q&A, advanced patterns discussion

### Handling Questions

**About MCP:**
- "Great question! MCP is optional - both paths work."
- "Let's save MCP deep dive for after the workshop."
- "Focus on the agentic patterns, not the tool."

**About BC specifics:**
- "Good catch! Let me show you in the .al-guidelines folder."
- "That's documented in performance-patterns.md - check it during exercises."

**About AI tools (Copilot, Claude, etc.):**
- "These patterns work with any AI assistant."
- "The collaboration approach matters more than the specific tool."

### Common Participant Challenges

**"My AI isn't suggesting what yours did"**
- Different AI tools have different capabilities, different models can give different results, and agents are non-deterministic!
- Focus on the conversation pattern, not exact output
- Show them how to refine prompts

**"I'm stuck on the exercise"**
- Redirect to stage README.md and exercise.md
- Pair them with someone who's progressing
- Show solution branch if they're completely blocked

**"Setup isn't working"**
- Have Codespace backup ready
- Pair programming: work with neighbor
- Continue on your demo environment if needed

---

## Demo Environment Setup

### Recommended Demo Setup

**Option A: Live BC Sandbox**
- Advantages: Real-time compilation, authentic experience
- Risks: Network issues, BC downtime
- Backup: Pre-record demo segments

**Option B: Local BC Docker Container**
- Advantages: No network dependency, faster
- Risks: Docker setup complexity
- Backup: Screenshots + narration

**Option C: Hybrid (Recommended)**
- Stage 1-2: Live demo
- Stage 3: Pre-recorded if time tight
- Backup slides for all stages

### Screen Sharing Best Practices

- **Font size:** 16-18pt minimum in VS Code
- **Hide distractions:** Close unrelated tabs, notifications off
- **Dual monitor:** Demo on one, notes on other
- **Slow down:** Type slowly, explain as you go
- **Zoom in:** Show code clearly during key moments

---

## Post-Workshop

### Immediate Follow-up (Same Day)

**Send to participants:**
- Links to solution branches
- Recording (if recorded)
- Feedback survey link
- Reminder about FACILITATOR-GUIDE.md for self-paced review

### Week After Workshop

**Share:**
- Blog post or internal wiki with key takeaways
- .al-guidelines folder as standalone resource
- Optional MCP installation guide (for those interested)

---

## Customizing for Your Team

### Shorter Workshop (60 min)

**Condense to:**
- Intro: 5 min
- Stage 1: Demo only (8 min) + brief exercise (5 min)
- Stage 2: Demo (8 min) + exercise (10 min)
- Stage 3: Demo (15 min) + discussion (9 min)

**Skip:** Individual exercises, focus on demos + Q&A

### Longer Workshop (3 hours)

**Add:**
- Extended exercises (30 min each stage)
- Advanced scenarios (webhook integration, API testing)
- Group code review sessions
- MCP installation workshop
- Custom feature implementation contest

### Internal Team Version

**Adapt:**
- Use your team's actual BC app instead of AmuseYou
- Real technical debt examples from your codebase
- Team-specific AL guidelines
- Integration with your CI/CD pipeline

---

## Troubleshooting During Workshop

### Technical Issues

**BC connection fails:**
- Use pre-recorded demo segments
- Continue with slides + discussion
- Share screen from working environment

**Git branch issues:**
- Provide solution code via chat/email
- Screen share your branches
- Manual code walkthrough

**Time running out:**
- Skip to Stage 3 demo (highlight reel)
- Assign Stage 1-2 as homework
- Focus on key concepts over completion

### Participant Engagement

**Low energy:**
- Quick poll: "What's your biggest AI collaboration challenge?"
- Live code together as group
- Pair programming exercises

**Too advanced/too basic:**
- Create fast/slow tracks
- Advanced folks help others (peer mentoring)
- Extra challenges for fast finishers

---

## Measuring Success

### During Workshop

**Observable indicators:**
- Participants actively trying planning prompts
- Questions about cross-layer dependencies
- Discussions comparing autocomplete vs agentic approaches

### Post-Workshop

**Survey questions:**
1. Can you explain autocomplete vs agentic thinking?
2. Will you use planning-first approach at work?
3. Did you learn new AL patterns?
4. Would you recommend this workshop?

**Success metrics:**
- 80%+ would recommend
- 70%+ will apply agentic patterns at work
- 90%+ can distinguish autocomplete vs agentic

---

## FAQ (Facilitator)

**Q: Should I require MCP installation?**
A: No - make it optional. File-based knowledge is a viable option if you can invest the time in building an instructionset.

**Q: What if participants use different AI tools (Copilot, Claude Code, Cursor)?**
A: Great! Show that patterns work across tools. Focus on conversation structure, not specific AI. GitHub Copilot Chat is recommended but not required.

**Q: Can I run this workshop remotely?**
A: Yes. Use breakout rooms for exercises, Slack/Teams for Q&A, screen sharing for demos.

**Q: Should I show solutions during exercises?**
A: No - let them struggle productively. Show solutions only in debrief or if someone is completely stuck.

**Q: What if I'm new to agentic collaboration myself?**
A: Perfect! Run through all exercises yourself first, document your own "aha moments", share your learning journey with participants.

---

## Resources for Facilitators

- **Demo scripts:** Each stage folder has demo-script.md
- **Timing guide:** This document (Workshop Timeline section)
- **Backup slides:** .docs/ folder (create if needed)
- **Community:** BC Discord, AL Language GitHub discussions

---

## Continuous Improvement

**After each workshop run:**
- Note what worked / what didn't
- Update exercise.md files based on participant feedback
- Refine demo scripts for clarity
- Add new troubleshooting scenarios to TROUBLESHOOTING.md

**Share improvements:**
- Pull request to workshop repo
- Blog about facilitation experience
- Share in BC community

---

## You're Ready!

✅ Pre-workshop email sent
✅ Solution branches created
✅ Demo environment tested
✅ Backup plan ready
✅ Read all demo scripts
✅ Comfortable with 105-minute timeline

**Go teach agentic collaboration! 🚀**

Questions? Create an issue in the workshop repository or reach out to the community.
