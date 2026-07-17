# Design History

History of key-design choices from latest to oldest.

## Post [61f8c09f14e4](https://github.com/velia-vito/yatte_component_editor/tree/61f8c09f14e4)

1. **Maximum estimated word-count at 250M words.** Some of the most prolific writers of out time,
   like GRRM, Stephen King, and even Asimov capped out at around 10M published words, assume theres
   about 7x more words of lore/notes per published word, and 5x more words for drafts, you still hit
   below the 500M count.

   | Author                 | Total Published Words (Estimate) | Notes (Estimate) | Drafts (Estimate) | Total Words |
   | :--------------------- | :------------------------------: | :--------------: | :---------------: | :---------: |
   | George R.R Martin      |              3.0 M               |      21.0 M      |      15.0 M       |   39.0 M    |
   | Tolkein                |              1.8 M               |      12.6 M      |       9.0 M       |   23.4 M    |
   | Wildbow[^1]            |              10.0 M              |      70.0 M      |      50.0 M       |   130.0 M   |
   | William Gibson         |              1.7 M               |      11.9 M      |       8.5 M       |   22.1 M    |
   | Jeff VanderMeer        |              2.5 M               |      17.5 M      |      12.5 M       |   32.5 M    |
   | Sir Arthur Conan Doyle |              7.0 M               |      49.0 M      |      35.0 M       |   91.0 M    |
   | Brandon Sanderson      |              8.0 M               |      56.0 M      |      40.0 M       |   104.0 M   |
   | Issac Asimov           |              7.6 M               |      53.2 M      |      38.0 M       |   98.8 M    |
   | Frank Herbert          |              3.4 M               |      23.8 M      |      17.0 M       |   44.2 M    |
   | Nassim Nicholas Taleb  |              1.5 M               |      10.5 M      |       7.5 M       |   19.5 M    |

[^1]: Fanfiction writer, infamous for writing the single longest knows FanFiction Series — Worm.

2. **Maximum latency increased from flat-10ms to 25ms $\pm$ 5ms**. A flat 10ms boundary is unreasonable,
   especially if the goal is to support things like RegExp over the total 250M word corpus. It also
   doesn't capture the actual goal of a "smooth, uninterrputed, responsive application."

   The new latency limits are as follows.

   | Latency Type            | Duration | Notes                                                                                                                                                                                |
   | :---------------------- | :------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
   | Input-To-Frame Max      |   25ms   | Max time between a an input and some visual response on screen. Research puts desktop interactions as _**instantaneous**_ below 60ms but mobile interatactions at a much lower 10ms. |
   | Frame-To-Frame Variance |   5ms    | How much the Frame-To-Frame time can vary. Research shows that a _**jitter**_ of just 4—8ms is subconciously perceptable to the average human.                                       |
