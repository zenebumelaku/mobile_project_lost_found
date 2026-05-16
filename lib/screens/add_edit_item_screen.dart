import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/item_provider.dart';

class AddEditItemScreen extends StatefulWidget {
  final LostFoundItem? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _contactCtrl;
  String _type = 'Lost';
  String _status = 'Active';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _titleCtrl = TextEditingController(text: i?.title ?? '');
    _descCtrl = TextEditingController(text: i?.description ?? '');
    _locationCtrl = TextEditingController(text: i?.location ?? '');
    _contactCtrl = TextEditingController(text: i?.contactInfo ?? '');
    _type = i?.type ?? 'Lost';
    _status = i?.status ?? 'Active';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final provider = context.read<ItemProvider>();
    final newItem = LostFoundItem(
      id: widget.item?.id,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      contactInfo: _contactCtrl.text.trim(),
      type: _type,
      status: _status,
    );

    final success = widget.item == null
        ? await provider.addItem(newItem)
        : await provider.editItem(newItem);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage.isNotEmpty
              ? provider.errorMessage
              : 'Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Item' : 'Report Item'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type selector
              const Text('Item Type',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: ['Lost', 'Found'].map((t) {
                  final selected = _type == t;
                  final color = t == 'Lost' ? Colors.red : Colors.green;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: t == 'Lost' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: selected ? color : Colors.grey.shade300,
                              width: 2),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4))
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              t == 'Lost'
                                  ? Icons.search_off_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: selected ? Colors.white : color,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t,
                              style: TextStyle(
                                color: selected ? Colors.white : color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              _buildCard([
                _buildField(_titleCtrl, 'Title', Icons.title_rounded,
                    hint: 'e.g. Black Wallet'),
                const Divider(height: 1),
                _buildField(_descCtrl, 'Description', Icons.description_rounded,
                    hint: 'Describe the item...', maxLines: 3),
              ]),
              const SizedBox(height: 14),

              _buildCard([
                _buildField(_locationCtrl, 'Location', Icons.location_on_rounded,
                    hint: 'e.g. Main Library'),
                const Divider(height: 1),
                _buildField(_contactCtrl, 'Contact Info', Icons.contact_phone_rounded,
                    hint: 'Email or phone number'),
              ]),
              const SizedBox(height: 14),

              // Status selector
              _buildCard([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.flag_rounded,
                          color: Colors.deepPurple.shade300, size: 20),
                      const SizedBox(width: 12),
                      const Text('Status',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _status,
                          items: ['Active', 'Claimed']
                              .map((s) => DropdownMenuItem(
                                  value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => _status = v!),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          isEditing ? 'Update Item' : 'Submit Report',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    String hint = '',
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon:
              Icon(icon, color: Colors.deepPurple.shade300, size: 20),
          border: InputBorder.none,
        ),
        validator: (v) =>
            v == null || v.trim().isEmpty ? '$label is required' : null,
      ),
    );
  }
}
