---
title: "Disk Soup: AWS, EBS, RAID, MarkLogic, and Pinch of Salt!"
date: "2013-06-26T06:12:31.666000Z"
url: "/journal/entry/2013-06-26T06:12:31.666000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - MarkLogic
  - AWS
  - RAID10
  - EBS
---

# Disk Soup: AWS, EBS, RAID, MarkLogic, and Pinch of Salt!

At the [2013 MarkLogic User Conference](http://www.marklogic.com/events/marklogic-world-2013/) , I learned all kinds of interesting and valuable information about running [MarkLogic](http://www.marklogic.com/) on [AWS (Amazon Web Services) EC2 servers.](http://aws.amazon.com/) Most specifically, it was mentioned that I wasn't necessarily going to get a huge performance gain over regular EBS storage via the RAID 10 configuration that I cooked up.  That was good news to me because it costs me quite a bit to have all that extra EBS storage for RAID10.

I just finally got around to testing all of this out with live data.  I trimmed down my data, merged all my forests, and cleaned up the disk to ensure I knew exactly how much storage I needed.  I finally got it all down to about 148GB of on-disk data for about 3+ months of weather data.

My current configuration is eight 200GB volumes arranged in a RAID 10 configuration.  That is 1.6TB of storage that yields about 750GB of usable disk space.

To consolidate this onto one volume, I created a 600GB EBS volume, created an ext4 filesystem, and copied all the data across while everything was shutdown.  And then I waited, and waited, copying is sure slow, and waited...

When I was finally ready, I started up MarkLogic and all my Web applications to test the throughput.  The result: **it was twice as slow!** I get at least a 2 times increase in performance by having RAID10 via mdadm.

Fortunately, the data hadn't changed and so I could easily switch back to the old filesystem.  I restarted MarkLogic and verified my measurements: *yes, RAID10/mdadm is better by at least twice.*

I then looked into [Provisioned IOPS](http://aws.amazon.com/about-aws/whats-new/2012/07/31/announcing-provisioned-iops-for-amazon-ebs/) and whether I could test that.  Unfortunately, it isn't available for the instance type I'm using ( [m2.xlarge](http://aws.amazon.com/ec2/instance-types/#instance-details) ) and I would have to move to the next level up (m2.2xlarge).  The additional cost of Provisioned IOPS for EBS and the m2.2xlarge removes any cost savings I might have had.

Here's the takeaway:

  * RAID10 via mdadm is a good middle ground for AWS.  It will give you better performance, possibly twice as fast as regular EBS storage.
  * RAID10 will cost you less for overall EBS storage than Provisioned IOPS.
  * Provisioned IOPS will give you better performance guarantees and you may find you want/need to pay for that.
  * I don't have a measurement of that as of yet.

I wish I had an easy way to test out Provisioned IOPS for EBS storage with my system.  It would be great to compare everything all at once.  Unfortunately, I would first have to upgrade to a different instance type and then re-run all the tests I've done so far.  For my current work, that isn't necessary.

Yet, when I want more performance, I now know what to do next.

