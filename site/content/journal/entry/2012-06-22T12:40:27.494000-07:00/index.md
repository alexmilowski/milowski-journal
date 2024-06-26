---
title: "Disk Space is Important!"
date: "2012-06-22T12:40:27.494000-07:00"
url: "/journal/entry/2012-06-22T12:40:27.494000-07:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - AWS
  - EBS
---


# Disk Space is Important!

Sometimes you learn interesting things under duress, reaffirm things you already know, and pay for not doing it right the first time.

It should come as no surprise that having enough disk space for MarkLogic is important but just what can happen when you run out was a bit of a surprise to me.  In my on-going project to store  “big weather data” , I have a constant stream of data flowing into MarkLogic.  About every five minutes, new weather reports are inserted.  While each set of reports are reasonable in side, the flow is constant such that the on-disk size of the forest grows by about 50GB a month.

My MarkLogic server runs in the cloud on an Amazon EC2 instance and I rationalized a smaller 300GB EBS volume was sufficient.  I thought I would enlarge the disk when I needed to do so.  Everything was working fine and so I didn't think too much about it again--rationalizing that I had awhile before I needed to be worried.

What was the worst that could happen?  The database would go offline?  Inserting new content would fail?

As an aside, there is a corollary to Murphy's law that says:  “When something goes wrong, you will be on vacation.” That's just what happened.  I was on vacation last week, pulled up my application, and nothing was working.  Poking around, I find that my MarkLogic server is inaccessible--really inaccessible.  That is, I can't even get into the server via ssh.

I rebooted the server via the AWS Console and all hell broke loose.  The server wouldn't boot because several of the EBS-based filesystems were corrupted.  To make things even more frustrating, the server booted into single-user mode which, since it is virtualized and running in the cloud, is completely inaccessible.  Viewing a system console where it asks you to type something, but you can't because you aren't anywhere near the actual machine, is very, very frustrating.

Making a long and arduous story short, I had to create new, small, empty filesystems and attach them as the devices that contained the corrupted filesystems, boot the server, and attempt to repair the old filesystems.  What I found was that the superblock on the database filesystem was trashed as well as all the copies.  Fortunately, I was able to retrieve the content using a wonderful program called [testdisk](http://www.cgsecurity.org/wiki/TestDisk) .

I created a much larger 750GB filesystem on which I restored the database files and made a snapshot of the whole volume.  Unfortunately, when I started MarkLogic, all my content had disappeared.  Alternating between wanting to cry, for I had no recent backup, and use of colorful language, I had to dig in for the long haul and see if I could recover everything.

Looking at the logs for MarkLogic, I noticed it was deleting all my content on startup.  I could repeat the process by creating a new filesystem from the snapshot, start MarkLogic, and watch it delete all my content.  This is when I noticed the `Obsolete` files in all the stand directories where each forest was stored.

If you're a MarkLogic engineer, you should now brace yourself for getting the shivers.

I deleted the `Obsolete` files and started up MarkLogic to see what would happen.  Of course, it didn't quite work the first time.  Turns out that the weather database still had problems but it didn't delete my website--this website that you are reading.  I marked that as progress.

I assumed there was more serious damage to the forest for the weather database and asked my MarkLogic friends for some help. Turns out there some extra files hanging out in the forest directory--probably from a merge that was in progress.   There were empty files named like stand directories and also empty stand directories.  I deleted these extra files, started up MarkLogic, and crossed my fingers.

MarkLogic took its time coming up and was rather silent about what was going on.  I let it go for awhile and then, like wishing on a shooting star, my database came back up like nothing had happened.

I don't know exactly why the system went down as the system logs just stop.  I do know that MarkLogic was complaining with critical errors about not having enough disk space to merge.  Keep in mind that new content was continuously streaming in and so the problem was getting worse and worse.  In the end, if I had to guess, I believe the OS just ran into some wall (like very low memory) and froze.  When I rebooted it via the AWS console, it trashed the filesystem because the disks weren't sync'd.

My website is easy to backup and I'll do that more often now.  The weather database is tricky because of its size.  I'm looking into using automatic EBS snapshots by taking the database and filesystem offline for a moment.  I can always re-create the weather database from scratch if I really need to do so as I have the raw XML source files but that would take quite awhile to do.

In the end, I was very lucky.

