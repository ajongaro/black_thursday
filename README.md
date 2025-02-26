## **Black Thursday**

### **Reflection Questions**
#### **1. What was the most challenging aspect of this project?**

Working with the CSV was a big challenge, we spent quite a bit of time on `from_csv` in `sales_engine.rb`. Additionally, understanding how each of the pieces of data (item, merchant, invoice_item, etc.) are connected. Figuring out the most efficient way to access specific data also proved to be difficult.

With the scope of this project and splitting up work, it was difficult to maintain an understanding of the connections between different pieces of data.

![alt text](https://i.ibb.co/HrRCgjX/Screen-Shot-2022-11-08-at-9-39-12-PM.png "Database Design Diagram")

We used db designer to model the classes for all of the items. This helped with accessing different data elements “through” various classes and recognizing their relationships to one another.

#### **2. What was the most exciting aspect of this project?**

Utilizing and implementing inheritance/modules was exciting and solidified the concept. 

#### **3. Describe the best choice enumerables you used in your project. Please include file names and line numbers.**

- `all?` in sales_analyst.rb:157 : 
This was the best choice because we needed a boolean returned confirming all met the condition.
- `each_key` / `each_value` in `sales_analyst_spec.rb`:476/480 : We learned about this method from rubocop and it fits since we were iterating through hashes only looking to check the key or value.
- `find_all` in `merchant_respository.rb`:12 : This was best because we needed an empty array in the event the condition is never met.

#### **4. Tell us about a module or superclass which helped you reuse code across repository classes. Why did you choose to use a superclass and/or a module?**

We used our MakeTime module across every class that included a `created_at` or `updated_at` attribute. We chose to make this module as it became clear that we were going to need a method to ‘cleanse’ time in several classes.

#### **5. Tell us about 1) a unit test and 2) an integration test that you are particularly proud of. Please include file name(s) and line number(s).**

A unit test we are proud of is the `add_to_repo` test in `the repository_spec.rb`:11. This test used mocks in place of creating an invoice instance which we haven’t had the opportunity to try before.
An integration test that we are proud of is the `top_merchants_by_invoice_count` test in the `sales_analyst_spec.rb`: 348. This method relies upon the integration of many things including several helper methods and the general function of the sales engine creating the repositories

#### **6. Is there anything else you would like instructors to know?**

Rubric requirements for this include a pretty strict rule on lines per method- we have broken this in several places. This is partly because it seemed difficult to extract any lines out of some methods without decreasing readability (ex: `sales_analyst.rb`:188). Additionally, several classes have 7 attributes so the initialize method is 7 lines (ex: item.rb:18).

If we had more time…
- We would have looked into refactoring the sales analyst class to make a standard deviation helper method that could be used several times.
- We would also have looked for other methods that could have been extracted from a class to put in our existing MakeTime module.



### **Blog Post**

For `most_sold_items_for_merchant`, the first thing we call on is a helper method, `items_and_quantities_sold_for(merchant_id)`. This creates a hash where the keys are all of the merchant’s items and all of the values are the quantity sold for that item. The default value is set to 0, so that when we enumerate through, all we have to do is add right into the value instead of checking to see if the value already exists.

This hash is created by iterating over the items and finding all of the items by merchant id and for each of those items, going through all of the invoice items and finding them by the item id. When it finds the invoice item that matches that item id it adds that quantity to the value for its corresponding item key as long as that invoice has at least one successful transaction.

After we call the helper method that creates the hash, we call `max_by` on the hash to look for what is the highest quantity and since there is a chance for a tie, we then go and use the select enumerator to look back in that hash and see all of the items that may have that highest quantity and return just the keys from the select enumerator to give us the most sold item(s).

The `best_item_for_merchant` only returns one item that has generated the most revenue for the merchant, so in addition to the number sold we also need to be aware of the unit price. We start by using a very similar helper method that we used in `most_sold_items_per_merchants`, this one is called `items_and_dollar_amount_sold`. For this method the keys are still all of the merchant’s items, but the values are the revenue generated by the item instead of being the quantity of items sold.

As we iterate through each item and each item’s invoice item, and confirm that the invoice is paid in full, we then add to the value the quantity times the unit price. Once this hash is created that holds all these items and the revenue that these items have generated, all we have to do is call `max_by` on that hash and have it return the first value in that array that is generated. That will be the item instance that has generated the most revenue for the given merchant. All four of the used methods take merchant id as the argument.

Utilizing `invoice_paid_in_full?` as a helper method was pivotal to making all of the above work. It ensures that items that aren’t actually bought/paid for don’t count towards revenue or other statistics (`best_item_for_merchant` and `items_and_quantities_sold` for merchants outcomes). 

Given more time, we’d like to make a sample set of data to improve testing on these particular methods. That would allow us to make certain assertions about what the exact outcomes should be for both of these methods. 

### **Q&A**

**Joe**

1. Where did this data come from? 😬
2. With the complex math related methods in `sales_analyst.rb` we tried to maintain SRP as much as possible. Can you please speak to improvements we could have made in that file (or elsewhere) to stick closer to this?
3. Can you address other opportunities for modules/superclasses that we may have missed?

**Anthony O.**

1. What’s the best way to approach finding/remembering best paths to desired data within various class attributes and such?

**Kelsie**

1. How could we have made our tests more efficient (run faster) in` sales_analyst`? It took almost a minute to run our tests **after** we had refactored. How do large code bases in the “real world” handle large data sets?

**Elle**

1. Are there more ways for parsing through or iterating over large CSV files more efficiently that we overlooked?
