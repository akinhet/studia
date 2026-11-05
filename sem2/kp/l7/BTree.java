public class BTree<T extends Comparable<T>> {
	private class BTreeNode {
		T val;
		BTreeNode left, right;

		protected BTreeNode(T val) {
			this.val = val;
		}
	}

	BTreeNode root = null;
	int size = 0;

	private BTreeNode searchForNode(T val) {
		BTreeNode ptr = root;
		while (ptr != null) {
			if (ptr.val == val) {
				return ptr;
			}

			if (ptr.val.compareTo(val) > 0)
				ptr = ptr.right;
			else
				ptr = ptr.left;
		}

		return null;
	}

	public boolean search(T val) {
		if (searchForNode(val) == null)
			return false;
		else
			return true;
	}

	public void insert(T val) {
		BTreeNode ptr = root,
				prev_ptr = null;
		if (ptr == null) {
			root = new BTreeNode(val);
			return;
		}

		while (ptr != null) {
			prev_ptr = ptr;
			if (ptr.val.compareTo(val) > 0)
				ptr = ptr.right;
			else
				ptr = ptr.left;
		}

		if (prev_ptr.val.compareTo(val) > 0)
			prev_ptr.right = new BTreeNode(val);
		else
			prev_ptr.left = new BTreeNode(val);
	}

	public void delete(T val) {
		BTreeNode ptr = root,
				prev_ptr = null;

		while (ptr != null && ptr.val == val) {
			prev_ptr = ptr;
			if (ptr.val.compareTo(val) > 0)
				ptr = ptr.right;
			else
				ptr = ptr.left;
		}

		if (ptr == null)
			return;

		if (ptr.left == null || ptr.right == null) {
			BTreeNode tmp = ptr.right;

			if (ptr.left == null)
				tmp = ptr.left;

			if (prev_ptr != null) {
				if (ptr == prev_ptr.left)
					prev_ptr.left = tmp;
				else
					prev_ptr.right = tmp;
			}
		} else {
			BTreeNode tmp = ptr.right,
					p = ptr;

			while (tmp.left != null) {
				p = tmp;
				tmp = tmp.left;
			}

			p.left = tmp.left;
			p.right = tmp.right;

			if (prev_ptr != null) {
				if (ptr == prev_ptr.left)
					prev_ptr.left = tmp;
				else
					prev_ptr.right = tmp;
			}
		}
	}
}
