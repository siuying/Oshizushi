# Oshizushi

## Summary

Oshizushi is a tool to layout views using Visual Formatting Language, without Auto Layout.

## Status

Planning.

## Sample Rules

```
|-5-[A(100)]
```

This means that element A is 5 points from the left edge of its container, and it's 100 points wide. And A has flexible right margin.

```
V:|-10-[B(50)]
```

This means that element B is 10 points from the top edge and is 50 points tall. (V means vertical). And B has flexible bottom margin.

```
|-5-[C]-5-|
```

This means that C has flexible width, and it's 5 points to the left edge and 5 points to the right edge.

```
V:[D]|
```

This means that D is touching the bottom edge, and have a flexible top margin, and D's height should be set beyond the VFL based block (either before or after)

```
|-5-[E]-5-[F(50)]-5-[G(>0)]-5-|
```

This means that E has a fixed width set outside the VFL block, F has a fixed width of 50 points, G has a flexible width

```
[H(100)]
```

This means that H is 100 points wide. However it's position and autoresizing mask is unknown, so you need to set them beyond the VFL block.

## Limitation

This is no Auto Layout and we will not support all features of it. 

### One flexible element

As a rule of thumb, there can be 1 and only 1 flexible element in each dimension:

```
|-5-[A(100)]-5-|
```

This is wrong because when the superview width is not 110 there will be a conflict.

```
|-5-[A(>0)]-5-[B(>0)]-5-|
```

This is wrong because it is an ambiguous layout—it is unclear on how to assign the widths for A and B.